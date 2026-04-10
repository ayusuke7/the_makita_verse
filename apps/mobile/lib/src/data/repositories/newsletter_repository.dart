import 'package:fpdart/fpdart.dart';

import '../../domain/domain.dart';
import '../data.dart';

class NewsLetterRepositoryImpl implements NewsLetterRepository {
  final NewsLetterDataSource _dataSource;

  List<ArticleEntity>? _cacheArticles;
  List<PodcastEntity>? _cachePodcasts;

  NewsLetterRepositoryImpl(this._dataSource);

  @override
  Future<Either<Exception, List<ArticleEntity>>> getArticles() async {
    if (_cacheArticles != null) {
      return Right(_cacheArticles!);
    }

    try {
      final articles = await _dataSource.getArticles();
      _cacheArticles = articles.map((a) => a.toEntity()).toList();
      return Right(_cacheArticles!);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, List<PodcastEntity>>> getPodcasts() async {
    if (_cachePodcasts != null) {
      return Right(_cachePodcasts!);
    }

    try {
      final podcasts = await _dataSource.getPodcasts();
      _cachePodcasts = podcasts.map((p) => p.toEntity()).toList();
      return Right(_cachePodcasts!);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, List<ArticleEntity>>> searchNews(
    String query,
  ) async {
    final news = <ArticleEntity>[];
    final q = query.toLowerCase();

    for (final a in _cacheArticles!) {
      final filtered = a.news
          .where(
            (n) =>
                n.title.toLowerCase().contains(q) ||
                n.content.toLowerCase().contains(q),
          )
          .toList();

      if (filtered.isNotEmpty) {
        news.add(a.copyWith(news: filtered));
      }
    }

    return Right(news);
  }

  @override
  Future<Either<Exception, List<NewsEntity>>> getSavedNews() async {
    try {
      final news = await _dataSource.getSavedNews();
      return Right(news.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, bool>> removeNews(NewsEntity news) async {
    try {
      final model = news.toModel();
      final result = await _dataSource.removeNews(model.id);
      return Right(result);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, bool>> saveNews(NewsEntity news) async {
    try {
      final model = news.toModel();
      final result = await _dataSource.saveNews(model);
      return Right(result);
    } catch (e) {
      return Left(e as Exception);
    }
  }
}
