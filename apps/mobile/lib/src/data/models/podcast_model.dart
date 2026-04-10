import '../../domain/domain.dart';
import 'models.dart';

class PodcastModel {
  final String url;
  final String title;
  final String subtitle;
  final String publishedAt;
  final List<CommentsModel> comments;
  final String? audioUrl;

  PodcastModel({
    required this.url,
    required this.title,
    required this.subtitle,
    required this.publishedAt,
    required this.comments,
    this.audioUrl,
  });

  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    return PodcastModel(
      url: json['url'],
      title: json['title'],
      subtitle: json['subtitle'],
      audioUrl: json['audio'],
      publishedAt: json['published_at'],
      comments: json['comments'] != null
          ? (json['comments'] as List<dynamic>)
                .map((e) => CommentsModel.fromJson(e))
                .toList()
          : [],
    );
  }

  PodcastEntity toEntity() {
    return PodcastEntity(
      url: url,
      title: title,
      subtitle: subtitle,
      audioUrl: audioUrl,
      publishedAt: publishedAt,
      comments: comments.map((e) => e.toEntity()).toList(),
    );
  }
}
