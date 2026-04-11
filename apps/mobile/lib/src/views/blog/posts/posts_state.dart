import '../../../domain/domain.dart';
import '../../../shared/shared.dart';

class PostsState extends BaseState {
  final List<BlogPostEntity> posts;
  final List<BlogPostEntity> searchPosts;
  final List<BlogPostEntity> savedPosts;

  const PostsState({
    super.status,
    super.error,
    this.posts = const [],
    this.savedPosts = const [],
    this.searchPosts = const [],
  });

  PostsState copyWith({
    List<BlogPostEntity>? posts,
    List<BlogPostEntity>? searchPosts,
    List<BlogPostEntity>? savedPosts,
    StateStatus? status,
    String? error,
  }) {
    return PostsState(
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
      final monthYear = '${post.month}, ${post.year}'.capitalize();
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
      final monthYear = '${post.month}, ${post.year}'.capitalize();
      if (map.containsKey(monthYear)) {
        map[monthYear]!.add(post);
      } else {
        map[monthYear] = [post];
      }
    }

    return map;
  }
}
