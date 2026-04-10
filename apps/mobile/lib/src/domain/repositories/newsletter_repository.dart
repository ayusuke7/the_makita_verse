import 'package:fpdart/fpdart.dart';

import '../domain.dart';

abstract interface class NewsLetterRepository {
  Future<Either<Exception, List<ArticleEntity>>> getArticles();
  Future<Either<Exception, List<PodcastEntity>>> getPodcasts();
  Future<Either<Exception, List<NewsEntity>>> searchNews(String query);

  Future<Either<Exception, List<NewsEntity>>> getSavedNews();
  Future<Either<Exception, bool>> saveNews(NewsEntity news);
  Future<Either<Exception, bool>> removeNews(NewsEntity news);
}
