import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';

abstract interface class BlogRepository {
  Future<Either<Exception, List<BlogPostEntity>>> getPosts();

  Future<Either<Exception, List<BlogPostEntity>>> getSavedPosts();
  Future<Either<Exception, bool>> savePost(BlogPostEntity post);
  Future<Either<Exception, bool>> removePost(BlogPostEntity post);
}
