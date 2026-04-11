import 'package:flutter/material.dart';

import 'blog.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        SegmentedButton(
          segments: const [
            ButtonSegment(
              value: 0,
              label: Text('Posts', softWrap: false),
            ),
            ButtonSegment(
              value: 1,
              label: Text('Saved', softWrap: false),
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
              PostsPage(),
              SavedPostPage(),
            ],
          ),
        ),
      ],
    );
  }
}
