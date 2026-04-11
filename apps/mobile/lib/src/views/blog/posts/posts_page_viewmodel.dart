import '../../../domain/domain.dart';
import '../../../shared/shared.dart';
import 'posts_state.dart';

class PostsPageViewModel extends BaseViewModel<PostsState> {
  final BlogRepository _blogRepository;

  PostsPageViewModel(
    this._blogRepository,
  ) : super(PostsState());

  void getPosts() async {
    if (state.posts.isNotEmpty) {
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

  void getSavedPosts() async {
    (await _blogRepository.getSavedPosts()).fold(
      (e) => null,
      (data) => emit(
        state.copyWith(
          savedPosts: data,
        ),
      ),
    );
  }

  void savePost(BlogPostEntity post) async {
    (await _blogRepository.savePost(post)).fold(
      (e) => null,
      (data) => getSavedPosts(),
    );
  }

  void removePost(BlogPostEntity post) async {
    (await _blogRepository.removePost(post)).fold(
      (e) => null,
      (data) => getSavedPosts(),
    );
  }

  void search(String query) {
    emit(state.copyWith(status: StateStatus.loading));

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
