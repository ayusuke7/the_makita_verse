import 'package:core/core.dart';

import 'articles_state.dart';

class ArticlesPageViewModel extends BaseViewModel<ArticlesState> {
  final NewsLetterRepository _newsletterRepository;

  ArticlesPageViewModel(
    this._newsletterRepository,
  ) : super(ArticlesState());

  void getArticles({bool refresh = false}) async {
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
    final result = await _newsletterRepository.getSavedNews();
    result.fold(
      (e) => null,
      (data) => emit(
        state.copyWith(
          savedNews: data,
        ),
      ),
    );
  }

  void saveNews(NewsEntity news) async {
    final result = await _newsletterRepository.saveNews(news);
    result.fold(
      (e) => null,
      (data) => getSavedNews(),
    );
  }

  void unsaveNews(NewsEntity news) async {
    final result = await _newsletterRepository.removeNews(news.id);
    result.fold(
      (e) => null,
      (data) => getSavedNews(),
    );
  }

  void changeSelectIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void clearSearch() {
    emit(
      state.copyWith(
        searchNews: [],
      ),
    );
  }

  void search(String query) async {
    if (state.status.isLoading) return;

    emit(
      state.copyWith(
        status: StateStatus.loading,
        searchNews: [],
      ),
    );
    final result = await _newsletterRepository.searchNews(query);
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
            searchNews: data,
          ),
        );
      },
    );
  }
}
