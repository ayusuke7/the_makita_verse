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
                  final expanded = key == postsByMonth.keys.first;

                  return ExpansionTile(
                    initiallyExpanded: expanded,
                    tilePadding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    shape: RoundedRectangleBorder(),
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    leading: Icon(Icons.calendar_month),
                    title: Text(
                      key,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: posts
                        .map((post) => PostItemCard(post: post))
                        .toList(),
                  );

                  // return Column(
                  //   children: [
                  //     ListTile(title: Text(key)),
                  //     ...posts.map((post) => PostItemCard(post: post)),
                  //   ],
                  // );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
