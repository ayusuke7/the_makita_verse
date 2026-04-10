import 'package:flutter/material.dart';
import 'package:the_makita_verse_app/src/views/views.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SegmentedButton(
          segments: const [
            ButtonSegment(
              value: 0,
              label: Text('Articles'),
            ),
            ButtonSegment(
              value: 1,
              label: Text('Podcasts'),
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
              ArticlesPage(),
              PodcastsPage(),
            ],
          ),
        ),
      ],
    );
  }
}
