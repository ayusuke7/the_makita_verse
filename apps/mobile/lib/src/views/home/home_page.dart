import 'package:flutter/material.dart';

import '../views.dart';

enum HomePageIndex {
  news,
  blog,
  channel,
  profile,
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
      .blog => 'AkitaOnRails Blog',
      .channel => 'Fabio Akita Channel',
      .profile => 'The MAkita Verse',
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: switch (_selectedIndex) {
        .news => NewsPage(),
        .blog => BlogPage(),
        .channel => ChannelPage(),
        .profile => ProfilePage(),
      },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex.index,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.grey.shade900,
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
            icon: Icon(Icons.newspaper),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
