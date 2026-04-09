import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../config/di.dart';
import 'blog_page_viewmodel.dart';
import 'components/post_detail.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final _searchController = TextEditingController();
  final _blogViewModel = it.get<BlogPageViewModel>();

  @override
  void initState() {
    super.initState();
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
                  final [m, y] = key.split('-');
                  final month = Helper.months[int.parse(m)];

                  return Column(
                    children: [
                      ListTile(title: Text('$month, $y')),
                      ...posts.map(
                        (post) => Card(
                          child: ListTile(
                            title: Text(
                              post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              child: Text(
                                '${post.formatedDate.day}'.padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetail(post: post),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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
