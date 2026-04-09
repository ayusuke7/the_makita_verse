import 'package:fpdart/fpdart.dart';

import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogDataSource _dataSource;

  List<BlogPostEntity>? _cachePosts;

  BlogRepositoryImpl(this._dataSource);

  @override
  Future<Either<Exception, List<BlogPostEntity>>> getPosts() async {
    if (_cachePosts != null) {
      return Right(_cachePosts!);
    }

    try {
      final posts = await _dataSource.getRssItems();
      _cachePosts = posts.map((p) => p.toEntity()).toList();
      return Right(_cachePosts!);
    } catch (e) {
      return Left(e as Exception);
    }
  }
}
