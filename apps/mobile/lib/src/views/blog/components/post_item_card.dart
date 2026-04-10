import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import 'post_detail.dart';

class PostItemCard extends StatelessWidget {
  final BlogPostEntity post;

  const PostItemCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
