import 'package:core/core.dart';

import 'blog_state.dart';

class BlogPageViewModel extends BaseViewModel<BlogState> {
  final BlogRepository _blogRepository;

  BlogPageViewModel(
    this._blogRepository,
  ) : super(BlogState());

  void getPosts({bool refresh = false}) async {
    if (state.posts.isNotEmpty && !refresh) {
      return;
    }

    emit(state.copyWith(status: StateStatus.loading));
    final result = await _blogRepository.getPosts();
    result.fold(
      (e) {
        emit(
          state.copyWith(
            status: StateStatus.error,
            error: e.toString(),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            status: StateStatus.success,
            posts: data,
          ),
        );
      },
    );
  }

  void search(String query) {
    emit(
      state.copyWith(
        status: StateStatus.loading,
      ),
    );

    final result = state.posts.where((post) {
      return post.title.toLowerCase().contains(query.toLowerCase()) ||
          post.content.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(
      state.copyWith(
        status: StateStatus.success,
        searchPosts: result,
      ),
    );
  }

  void clearSearch() {
    emit(
      state.copyWith(
        searchPosts: [],
      ),
    );
  }
}
