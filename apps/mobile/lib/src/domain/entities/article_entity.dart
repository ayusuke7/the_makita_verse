import '../../data/data.dart';
import '../domain.dart';

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

  ArticleEntity copyWith({
    String? url,
    String? title,
    String? subtitle,
    String? publishedAt,
    List<NewsEntity>? news,
  }) {
    return ArticleEntity(
      url: url ?? this.url,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      publishedAt: publishedAt ?? this.publishedAt,
      news: news ?? this.news,
    );
  }
}

class NewsEntity {
  final String id;
  final String title;
  final String image;
  final String category;
  final String content;
  final String source;
  final String publishedAt;
  final List<LinksEntity> links;
  final List<CommentsEntity> comments;

  NewsEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.content,
    required this.source,
    required this.publishedAt,
    required this.links,
    required this.comments,
  });

  String get contentText => content.replaceAll(RegExp(r'<[^>]*>'), '');

  NewsModel toModel() {
    return NewsModel(
      title: title,
      image: image,
      category: category,
      content: content,
      source: source,
      publishedAt: publishedAt,
      links: links.map((l) => l.toModel()).toList(),
      comments: comments.map((c) => c.toModel()).toList(),
    );
  }
}

class LinksEntity {
  final String url;
  final String title;

  LinksEntity({required this.url, required this.title});

  LinksModel toModel() {
    return LinksModel(
      url: url,
      title: title,
    );
  }
}
