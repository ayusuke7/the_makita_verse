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

  @override
  Future<Either<Exception, List<BlogPostEntity>>> getSavedPosts() async {
    try {
      final posts = await _dataSource.getSavedRssItems();
      return Right(posts.map((p) => p.toEntity()).toList());
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, bool>> removePost(BlogPostEntity post) async {
    try {
      final model = post.toModel();
      final result = await _dataSource.removeRssItem(model.id);
      return Right(result);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, bool>> savePost(BlogPostEntity post) async {
    try {
      final result = await _dataSource.saveRssItem(post.toModel());
      return Right(result);
    } catch (e) {
      return Left(e as Exception);
    }
  }
}
