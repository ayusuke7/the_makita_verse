import '../../domain/domain.dart';
import '../../shared/shared.dart';
import 'bookmarks.dart';

class BookmarkViewModel extends BaseViewModel<BookmarkState> {
  final NewsLetterRepository _newsletterRepository;
  final BlogRepository _blogRepository;

  BookmarkViewModel(
    this._newsletterRepository,
    this._blogRepository,
  ) : super(const BookmarkState());

  void getSavedNews() async {
    emit(state.copyWith(status: StateStatus.loading));
    (await _newsletterRepository.getSavedNews()).fold(
      (e) => emit(
        state.copyWith(
          status: StateStatus.error,
          error: e.toString(),
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: StateStatus.success,
          news: data,
        ),
      ),
    );
  }

  void getSavedPosts() async {
    (await _blogRepository.getSavedPosts()).fold(
      (e) => emit(
        state.copyWith(
          status: StateStatus.error,
          error: e.toString(),
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: StateStatus.success,
          posts: data,
        ),
      ),
    );
  }
}
