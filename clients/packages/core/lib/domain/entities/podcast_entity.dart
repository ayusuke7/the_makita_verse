import 'entities.dart';

class PodcastEntity {
  final String url;
  final String title;
  final String subtitle;
  final String publishedAt;
  final List<CommentsEntity> comments;
  final String? audioUrl;

  PodcastEntity({
    required this.url,
    required this.title,
    required this.subtitle,
    required this.publishedAt,
    required this.comments,
    this.audioUrl,
  });

  Map<String, dynamic> toJson() => {
    'url': url,
    'title': title,
    'audio': audioUrl,
    'subtitle': subtitle,
    'published_at': publishedAt,
    'comments': comments.map((c) => c.toJson()).toList(),
  };
}
