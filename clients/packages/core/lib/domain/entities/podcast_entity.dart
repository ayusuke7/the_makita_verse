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
}
