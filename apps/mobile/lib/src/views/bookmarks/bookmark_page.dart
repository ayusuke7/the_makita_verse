import 'package:flutter/material.dart';
import 'package:the_makita_verse_app/src/domain/domain.dart';

import '../../config/config.dart';
import '../blog/blog.dart';
import '../news/news.dart';
import 'bookmarks.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final _bookmarkViewModel = it.get<BookmarkViewModel>();
  final _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _bookmarkViewModel.getSavedNews();
    _bookmarkViewModel.getSavedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Bookmarks'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _bookmarkViewModel,
        builder: (context, state, child) {
          if (state.status.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status.isError) {
            return Center(
              child: Text('Oops! Something went wrong'),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 20),
              SegmentedButton(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    label: Text('News'),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text('Posts'),
                  ),
                ],
                selected: {_selectedIndex},
                onSelectionChanged: (value) {
                  _pageController.animateToPage(
                    value.first,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                  setState(() {
                    _selectedIndex = value.first;
                  });
                },
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _selectedIndex = page;
                    });
                  },
                  children: [
                    _buildNewsList(state.news),
                    _buildPostList(state.posts),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNewsList(List<NewsEntity> news) {
    if (news.isEmpty) {
      return const Center(
        child: Text('No saved news'),
      );
    }

    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: news.length,
      itemBuilder: (context, index) {
        final item = news[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item.image),
            ),
            title: Text(
              item.title,
              softWrap: false,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              item.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetail(news: item),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPostList(List<BlogPostEntity> posts) {
    if (posts.isEmpty) {
      return const Center(
        child: Text('No saved posts'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final item = posts[index];
        return PostItemCard(post: item);
      },
    );
  }
}
