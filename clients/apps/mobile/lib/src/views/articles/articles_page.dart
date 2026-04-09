import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../config/di.dart';
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

  void _showArticles() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: _articleViewModel,
          builder: (context, state, child) {
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                final [title, subtitle] = article.title.split('-');
                return ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(subtitle),
                  leading: Icon(Icons.calendar_month),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Navigator.pop(context);
                    _articleViewModel.changeSelectIndex(index);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

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
        Widget content = const SizedBox.shrink();

        if (state.status.isLoading) {
          content = ListView.builder(
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
          content = SizedBox(
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

        if (state.status.isSuccess) {
          final news = state.searchNews.isNotEmpty
              ? state.searchNews
              : state.articleNews;

          content = Column(
            children: [
              ListTile(
                title: Text(
                  state.article?.title ?? 'Latest news',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(Icons.calendar_month),
                trailing: Icon(Icons.arrow_drop_down),
                onTap: _showArticles,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    final newsItem = news[index];
                    return NewsCard(
                      news: newsItem,
                      isSaved: state.savedNews.contains(newsItem),
                      onSave: () {
                        _articleViewModel.saveNews(newsItem);
                      },
                      onShare: () {
                        Launch.openLink(newsItem.source);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputSearch(
              controller: _searchController,
              onChanged: _articleViewModel.search,
              hintText: 'Search',
              isClear: state.searchNews.isNotEmpty,
              onClear: () {
                _searchController.clear();
                _articleViewModel.clearSearch();
              },
            ),
            Expanded(
              child: content,
            ),
          ],
        );
      },
    );
  }
}
