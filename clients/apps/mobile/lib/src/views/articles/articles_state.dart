import 'package:core/core.dart';

class ArticlesState extends BaseState {
  final List<ArticleEntity> articles;
  final List<NewsEntity> searchNews;
  final List<NewsEntity> savedNews;

  final int selectedIndex;

  const ArticlesState({
    super.status,
    super.error,
    this.selectedIndex = 0,
    this.articles = const [],
    this.savedNews = const [],
    this.searchNews = const [],
  });

  ArticlesState copyWith({
    StateStatus? status,
    String? error,
    int? selectedIndex,
    List<NewsEntity>? savedNews,
    List<NewsEntity>? searchNews,
    List<ArticleEntity>? articles,
  }) {
    return ArticlesState(
      error: error ?? this.error,
      status: status ?? this.status,
      articles: articles ?? this.articles,
      savedNews: savedNews ?? this.savedNews,
      searchNews: searchNews ?? this.searchNews,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [
    status,
    error,
    articles,
    savedNews,
    searchNews,
    selectedIndex,
  ];

  ArticleEntity? get article {
    if (articles.isEmpty || selectedIndex >= articles.length) {
      return null;
    }

    return articles[selectedIndex];
  }

  List<NewsEntity> get articleNews {
    if (article == null) {
      return [];
    }

    return article!.news;
  }

  List<NewsEntity> get allArticlesNews {
    if (articles.isEmpty) {
      return [];
    }

    return articles
        .map((article) => article.news)
        .expand((news) => news)
        .toList();
  }
}
