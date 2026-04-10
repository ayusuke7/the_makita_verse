import '../../../domain/domain.dart';
import '../../../shared/shared.dart';
import 'articles_state.dart';

class ArticlesPageViewModel extends BaseViewModel<ArticlesState> {
  final NewsLetterRepository _newsletterRepository;

  ArticlesPageViewModel(
    this._newsletterRepository,
  ) : super(ArticlesState());

  void getArticles() async {
    emit(
      state.copyWith(
        status: StateStatus.loading,
      ),
    );
    final result = await _newsletterRepository.getArticles();
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
            articles: data,
          ),
        );
      },
    );
  }

  void getSavedNews() async {
    (await _newsletterRepository.getSavedNews()).fold(
      (e) => null,
      (data) => emit(
        state.copyWith(
          savedNews: data,
        ),
      ),
    );
  }

  void saveNews(NewsEntity news) async {
    (await _newsletterRepository.saveNews(news)).fold(
      (e) => null,
      (data) => getSavedNews(),
    );
  }

  void unsaveNews(NewsEntity news) async {
    (await _newsletterRepository.removeNews(news)).fold(
      (e) => null,
      (data) => getSavedNews(),
    );
  }

  void clearSearch() {
    emit(
      state.copyWith(
        searchNews: [],
      ),
    );
  }

  void search(String query) async {
    (await _newsletterRepository.searchNews(query)).fold(
      (e) => null,
      (data) => emit(
        state.copyWith(
          searchNews: data,
        ),
      ),
    );
  }
}
