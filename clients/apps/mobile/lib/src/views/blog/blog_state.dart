import 'package:core/core.dart';

class BlogState extends BaseState {
  final List<BlogPostEntity> posts;
  final List<BlogPostEntity> searchPosts;

  const BlogState({
    super.status,
    super.error,
    this.posts = const [],
    this.searchPosts = const [],
  });

  BlogState copyWith({
    List<BlogPostEntity>? posts,
    List<BlogPostEntity>? searchPosts,
    StateStatus? status,
    String? error,
  }) {
    return BlogState(
      posts: posts ?? this.posts,
      searchPosts: searchPosts ?? this.searchPosts,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [posts, searchPosts, status, error];

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
