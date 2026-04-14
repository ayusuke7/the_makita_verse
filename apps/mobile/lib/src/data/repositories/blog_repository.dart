import 'package:fpdart/fpdart.dart';

import '../../domain/domain.dart';
import '../data.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogDataSource _dataSource;

  List<BlogPostEntity>? _cachePosts;
  List<TranscriptEntity>? _cacheTranscripts;

  BlogRepositoryImpl(this._dataSource);

  @override
  Future<Either<Exception, List<BlogPostEntity>>> getPosts() async {
    if (_cachePosts != null) {
      return Right(_cachePosts!);
    }

    try {
      final posts = await _dataSource.getBlogPosts();
      _cachePosts = posts.map((p) => p.toEntity()).toList();
      return Right(_cachePosts!);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, List<BlogPostEntity>>> getSavedPosts() async {
    try {
      final posts = await _dataSource.getSavedBlogPosts();
      return Right(posts.map((p) => p.toEntity()).toList());
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, bool>> removePost(BlogPostEntity post) async {
    try {
      final result = await _dataSource.removeBlogPost(post.id);
      return Right(result);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, bool>> savePost(BlogPostEntity post) async {
    try {
      final result = await _dataSource.saveBlogPost(post.toModel());
      return Right(result);
    } catch (e) {
      return Left(e as Exception);
    }
  }

  @override
  Future<Either<Exception, List<TranscriptEntity>>> getTranscripts() async {
    if (_cacheTranscripts != null) {
      return Right(_cacheTranscripts!);
    }

    try {
      final transcripts = await _dataSource.getTranscripts();
      _cacheTranscripts = transcripts.map((t) => t.toEntity()).toList();
      return Right(_cacheTranscripts!);
    } catch (e) {
      return Left(e as Exception);
    }
  }
}
