import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../blog_page_viewmodel.dart';

class PostDetail extends StatefulWidget {
  final BlogPostEntity post;

  const PostDetail({
    super.key,
    required this.post,
  });

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final _blogViewModel = it.get<BlogPageViewModel>();

  void _handleLinkTap(String? url) {
    if (url == null) return;

    if (url.startsWith('http')) {
      Launch.openLink(url);
      return;
    }

    if (url.startsWith('/')) {
      final index = _blogViewModel.state.posts.indexWhere(
        (p) => p.link.contains(url),
      );
      if (index > -1) {
        final post = _blogViewModel.state.posts[index];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetail(post: post),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () {
              Launch.openLink(widget.post.link);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          ListTile(
            title: Text(
              widget.post.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.post.pubDate,
              textAlign: TextAlign.center,
            ),
          ),
          Html(
            data: widget.post.content,
            onLinkTap: (url, _, _) {
              _handleLinkTap(url);
            },
            style: {
              'body': Style(
                fontSize: FontSize(16),
                fontWeight: FontWeight.bold,
              ),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade700,
        foregroundColor: Colors.white,
        child: Icon(Icons.bookmark_outline),
        onPressed: () {},
      ),
    );
  }
}
