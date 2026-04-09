import 'package:core/core.dart';

class BlogState extends BaseState {
  final List<BlogPostEntity> posts;
  final List<BlogPostEntity> searchPosts;
  final List<BlogPostEntity> savedPosts;

  const BlogState({
    super.status,
    super.error,
    this.posts = const [],
    this.savedPosts = const [],
    this.searchPosts = const [],
  });

  BlogState copyWith({
    List<BlogPostEntity>? posts,
    List<BlogPostEntity>? searchPosts,
    List<BlogPostEntity>? savedPosts,
    StateStatus? status,
    String? error,
  }) {
    return BlogState(
      error: error ?? this.error,
      posts: posts ?? this.posts,
      savedPosts: savedPosts ?? this.savedPosts,
      status: status ?? this.status,
      searchPosts: searchPosts ?? this.searchPosts,
    );
  }

  @override
  List<Object?> get props => [posts, searchPosts, status, error, savedPosts];

  Map<String, List<BlogPostEntity>> get postsByMonthYear {
    final map = <String, List<BlogPostEntity>>{};

    for (var post in posts) {
      final monthYear = '${post.formatedDate.month}-${post.formatedDate.year}';
      if (map.containsKey(monthYear)) {
        map[monthYear]!.add(post);
      } else {
        map[monthYear] = [post];
      }
    }

    return map;
  }

  Map<String, List<BlogPostEntity>> get searchPostsByMonthYear {
    final map = <String, List<BlogPostEntity>>{};
    for (var post in searchPosts) {
      final monthYear = '${post.formatedDate.month}-${post.formatedDate.year}';
      if (map.containsKey(monthYear)) {
        map[monthYear]!.add(post);
      } else {
        map[monthYear] = [post];
      }
    }

    return map;
  }
}
