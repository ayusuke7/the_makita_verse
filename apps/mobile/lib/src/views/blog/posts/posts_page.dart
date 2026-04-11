import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../../../shared/shared.dart';
import 'posts_page_viewmodel.dart';
import 'components/post_item_card.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _searchController = TextEditingController();
  final _blogViewModel = it.get<PostsPageViewModel>();

  @override
  void initState() {
    super.initState();
    _blogViewModel.getSavedPosts();
    _blogViewModel.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _blogViewModel,
      builder: (context, state, child) {
        if (state.status.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        }

        if (state.status.isError) {
          return Center(
            child: Text('Ops! something went wrong'),
          );
        }

        final postsByMonth = state.searchPosts.isEmpty
            ? state.postsByMonthYear
            : state.searchPostsByMonthYear;

        return Column(
          children: [
            InputSearch(
              hintText: 'Search',
              controller: _searchController,
              onChanged: _blogViewModel.search,
              isClear: state.searchPosts.isNotEmpty,
              onClear: () {
                _blogViewModel.clearSearch();
                _searchController.clear();
              },
            ),
            Expanded(
              child: ListView(
                children: postsByMonth.keys.map((key) {
                  final posts = postsByMonth[key]!;

                  return Column(
                    children: [
                      ListTile(title: Text(key)),
                      ...posts.map((post) => PostItemCard(post: post)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
