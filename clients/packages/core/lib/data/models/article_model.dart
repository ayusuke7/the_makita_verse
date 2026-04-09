import 'package:core/core.dart';

class ArticleModel {
  final String url;
  final String title;
  final String subtitle;
  final String publishedAt;
  final List<NewsModel> news;

  ArticleModel({
    required this.url,
    required this.title,
    required this.subtitle,
    required this.publishedAt,
    required this.news,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      url: json['url'],
      title: json['title'],
      subtitle: json['subtitle'],
      publishedAt: json['published_at'],
      news: json['news'] != null
          ? (json['news'] as List<dynamic>)
                .map((e) => NewsModel.fromJson(e))
                .toList()
          : [],
    );
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
      url: url,
      title: title,
      subtitle: subtitle,
      publishedAt: publishedAt,
      news: news.map((n) => n.toEntity()).toList(),
    );
  }
}

class NewsModel {
  final String title;
  final String image;
  final String category;
  final String content;
  final String source;
  final String publishedAt;
  final List<LinksModel> links;
  final List<CommentsModel> comments;

  NewsModel({
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

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'],
      image: json['image'],
      category: json['category'],
      content: json['content'],
      source: json['source'],
      publishedAt: json['published_at'],
      links: json['links'] != null
          ? (json['links'] as List<dynamic>)
                .map((e) => LinksModel.fromJson(e))
                .toList()
          : [],
      comments: json['comments'] != null
          ? (json['comments'] as List<dynamic>)
                .map((e) => CommentsModel.fromJson(e))
                .toList()
          : [],
    );
  }

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

  NewsEntity toEntity() {
    return NewsEntity(
      id: id,
      title: title,
      image: image,
      category: category,
      content: content,
      source: source,
      publishedAt: publishedAt,
      links: links.map((l) => l.toEntity()).toList(),
      comments: comments.map((c) => c.toEntity()).toList(),
    );
  }
}

class LinksModel {
  final String url;
  final String title;

  LinksModel({required this.url, required this.title});

  factory LinksModel.fromJson(Map<String, dynamic> json) {
    return LinksModel(url: json['url'], title: json['title']);
  }

  Map<String, dynamic> toJson() => {'url': url, 'title': title};

  LinksEntity toEntity() {
    return LinksEntity(url: url, title: title);
  }
}
