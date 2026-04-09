import 'dart:io';

import 'package:core/core.dart';

class BlogPostEntity {
  final String id;
  final String title;
  final String link;
  final String description;
  final String pubDate;
  final String guid;
  final String category;
  final String content;

  BlogPostEntity({
    required this.id,
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    required this.guid,
    required this.category,
    required this.content,
  });

  DateTime get formatedDate {
    return HttpDate.parse(pubDate);
  }

  RssItemModel toModel() {
    return RssItemModel(
      title: title,
      link: link,
      description: description,
      pubDate: pubDate,
      guid: guid,
      category: category,
      content: content,
    );
  }
}
