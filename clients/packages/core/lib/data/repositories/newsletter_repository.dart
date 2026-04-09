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
  Future<Either<Exception, List<NewsEntity>>> searchNews(String query) async {
    if (_cacheArticles == null) {
      return Right([]);
    }

    final news = _cacheArticles!.fold(<NewsEntity>[], (b, a) {
      final q = query.toLowerCase();
      if (a.news.any(
        (n) =>
            n.title.toLowerCase().contains(q) ||
            n.content.toLowerCase().contains(q),
      )) {
        b.addAll(a.news);
      }
      return b;
    });
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
  Future<Either<Exception, bool>> removeNews(String newsId) async {
    try {
      final result = await _dataSource.removeNews(newsId);
      return Right(result);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, bool>> saveNews(NewsEntity news) async {
    try {
      final model = NewsModel.fromJson(news.toJson());
      final result = await _dataSource.saveNews(model);
      return Right(result);
    } catch (e) {
      return Left(e as Exception);
    }
  }
}
