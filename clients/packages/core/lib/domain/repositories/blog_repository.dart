import 'package:fpdart/fpdart.dart';

import '../entities/entities.dart';

abstract interface class BlogRepository {
  Future<Either<Exception, List<BlogPostEntity>>> getPosts();
}
