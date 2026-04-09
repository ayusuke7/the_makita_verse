import 'package:flutter/material.dart';

import '../views.dart';

enum HomePageIndex {
  news,
  podcasts,
  blog,
  channel,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageIndex _selectedIndex = HomePageIndex.news;

  @override
  Widget build(BuildContext context) {
    String title = switch (_selectedIndex) {
      .news => 'The M.Akita Chronicles',
      .podcasts => 'The M.Akita Chronicles',
      .blog => 'AkitaOnRails Blog',
      .channel => 'Fabio Akita Channel',
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: switch (_selectedIndex) {
        .news => ArticlesPage(),
        .podcasts => PodcastsPage(),
        .blog => BlogPage(),
        .channel => ChannelPage(),
      },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex.index,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = HomePageIndex.values[index];
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.podcasts),
            label: 'Podcasts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Videos',
          ),
        ],
      ),
    );
  }
}
