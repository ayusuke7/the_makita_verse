import 'package:flutter/material.dart';
import 'package:the_makita_verse_app/src/config/config.dart';

import '../news.dart';

class SavedNewsPage extends StatefulWidget {
  const SavedNewsPage({super.key});

  @override
  State<SavedNewsPage> createState() => _SavedNewsPageState();
}

class _SavedNewsPageState extends State<SavedNewsPage> {
  final _articleViewModel = it.get<ArticlesPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _articleViewModel,
      builder: (context, state, child) {
        if (state.savedNews.isEmpty) {
          return const Center(
            child: Text('No saved news'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
          itemCount: state.savedNews.length,
          itemBuilder: (context, index) {
            final news = state.savedNews[index];
            return NewsCard(
              news: news,
              isSaved: true,
              onSave: () => _articleViewModel.unsaveNews(news),
            );
          },
        );
      },
    );
  }
}
