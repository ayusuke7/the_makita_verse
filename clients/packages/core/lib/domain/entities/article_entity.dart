import 'entities.dart';

class ArticleEntity {
  final String url;
  final String title;
  final String subtitle;
  final String publishedAt;
  final List<NewsEntity> news;

  ArticleEntity({
    required this.url,
    required this.title,
    required this.subtitle,
    required this.publishedAt,
    required this.news,
  });
}

class NewsEntity {
  final String title;
  final String image;
  final String category;
  final String content;
  final String source;
  final String publishedAt;
  final List<LinksEntity> links;
  final List<CommentsEntity> comments;

  NewsEntity({
    required this.title,
    required this.image,
    required this.category,
    required this.content,
    required this.source,
    required this.publishedAt,
    required this.links,
    required this.comments,
  });

  String get id => title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();

  Map<String, dynamic> toJson() => {
    'title': title,
    'image': image,
    'category': category,
    'content': content,
    'source': source,
    'published_at': publishedAt,
    'links': links.map((l) => l.toJson()).toList(),
    'comments': comments.map((c) => c.toJson()).toList(),
  };
}

class LinksEntity {
  final String url;
  final String title;

  LinksEntity({
    required this.url,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
    'url': url,
    'title': title,
  };
}
