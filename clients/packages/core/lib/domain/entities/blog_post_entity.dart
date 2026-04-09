import 'dart:io';

class BlogPostEntity {
  final String title;
  final String link;
  final String description;
  final String pubDate;
  final String guid;
  final String category;
  final String content;

  BlogPostEntity({
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
}
