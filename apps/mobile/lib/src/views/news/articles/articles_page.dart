import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../../../shared/shared.dart';
import 'articles_page_viewmodel.dart';
import 'components/news_card.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final _articleViewModel = it.get<ArticlesPageViewModel>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _articleViewModel.getSavedNews();
    _articleViewModel.getArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _articleViewModel,
      builder: (context, state, child) {
        if (state.status.isLoading) {
          return ListView.builder(
            itemCount: 4,
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white.withValues(alpha: 0.2),
                margin: EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  height: 250,
                  width: double.maxFinite,
                ),
              );
            },
          );
        }

        if (state.status.isError) {
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Sorry, something went wrong'),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    _articleViewModel.getArticles();
                  },
                ),
              ],
            ),
          );
        }

        final articles = state.searchNews.isNotEmpty
            ? state.searchNews
            : state.articles;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputSearch(
              hintText: 'Search',
              controller: _searchController,
              onChanged: _articleViewModel.search,
              isClear: state.searchNews.isNotEmpty,
              onClear: () {
                _searchController.clear();
                _articleViewModel.clearSearch();
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  final expanded = index == 0;

                  return ExpansionTile(
                    initiallyExpanded: expanded,
                    tilePadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    shape: RoundedRectangleBorder(),
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    leading: Icon(Icons.calendar_month),
                    title: Text(
                      article.title,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      ...article.news.map((news) {
                        final isSaved = state.savedNews.any(
                          (e) => e.id == news.id,
                        );
                        return NewsCard(
                          news: news,
                          isSaved: isSaved,
                          onSave: () {
                            if (isSaved) {
                              _articleViewModel.unsaveNews(news);
                            } else {
                              _articleViewModel.saveNews(news);
                            }
                          },
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
