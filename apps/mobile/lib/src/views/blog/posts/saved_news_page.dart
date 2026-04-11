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

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
          itemCount: state.savedPosts.length,
          itemBuilder: (context, index) {
            final post = state.savedPosts[index];
            return PostItemCard(post: post);
          },
        );
      },
    );
  }
}
