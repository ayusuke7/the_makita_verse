import 'package:the_makita_verse_app/src/domain/domain.dart';

import '../../shared/shared.dart';

class BookmarkState extends BaseState {
  final List<NewsEntity> news;
  final List<BlogPostEntity> posts;

  const BookmarkState({
    super.status,
    super.error,
    this.news = const [],
    this.posts = const [],
  });

  @override
  List<Object?> get props => [
    status,
    error,
    news,
    posts,
  ];

  BookmarkState copyWith({
    StateStatus? status,
    String? error,
    List<NewsEntity>? news,
    List<BlogPostEntity>? posts,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      error: error ?? this.error,
      news: news ?? this.news,
      posts: posts ?? this.posts,
    );
  }
}
