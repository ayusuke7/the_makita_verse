import 'package:flutter/material.dart';
import 'package:the_makita_verse_app/src/config/config.dart';

import '../blog.dart';

class SavedPostPage extends StatefulWidget {
  const SavedPostPage({super.key});

  @override
  State<SavedPostPage> createState() => _SavedPostPageState();
}

class _SavedPostPageState extends State<SavedPostPage> {
  final _articleViewModel = it.get<PostsPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _articleViewModel,
      builder: (context, state, child) {
        if (state.savedPosts.isEmpty) {
          return const Center(
            child: Text('No saved news'),
          );
        }

        return ListView(
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          children: state.savedPostsByMonthYear.keys.map((key) {
            final posts = state.savedPostsByMonthYear[key]!;
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(20, 20, 10, 5),
                  leading: Icon(Icons.calendar_month),
                  title: Text(
                    key,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...posts.map((post) => PostItemCard(post: post)),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
