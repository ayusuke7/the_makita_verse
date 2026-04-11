import '../../domain/domain.dart';

class BlogPostModel {
  final String url;
  final String title;
  final String publishedAt;

  final String content;

  BlogPostModel({
    required this.url,
    required this.title,
    required this.content,
    required this.publishedAt,
  });

  String get id => title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();

  factory BlogPostModel.fromJson(Map<String, dynamic> json) {
    return BlogPostModel(
      title: json['title'],
      url: json['url'],
      content: json['content'],
      publishedAt: json['published_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'content': content,
      'published_at': publishedAt,
    };
  }

  BlogPostEntity toEntity() {
    return BlogPostEntity(
      id: id,
      url: url,
      title: title,
      content: content,
      publishedAt: publishedAt,
    );
  }
}
