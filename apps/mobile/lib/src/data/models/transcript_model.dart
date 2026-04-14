import '../../domain/domain.dart';

class TranscriptModel {
  final String url;
  final String videoUrl;
  final String title;
  final String transcript;
  final String publishedAt;
  final List<String> chapters;
  final List<TranscriptLink> links;

  TranscriptModel({
    required this.url,
    required this.title,
    required this.videoUrl,
    required this.links,
    required this.chapters,
    required this.transcript,
    required this.publishedAt,
  });

  factory TranscriptModel.fromJson(Map<String, dynamic> json) =>
      TranscriptModel(
        url: json["url"],
        title: json["title"],
        videoUrl: json["video_url"],
        transcript: json["transcript"],
        publishedAt: json["published_at"],
        links: json["links"] == null
            ? []
            : List<TranscriptLink>.from(
                json["links"].map((x) => TranscriptLink.fromJson(x)),
              ),
        chapters: json["chapters"] == null
            ? []
            : List<String>.from(json["chapters"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "url": url,
    "video_url": videoUrl,
    "title": title,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "chapters": List<dynamic>.from(chapters.map((x) => x)),
    "transcript": transcript,
    "published_at": publishedAt,
  };

  TranscriptEntity toEntity() => TranscriptEntity(
    url: url,
    title: title,
    videoUrl: videoUrl,
    chapters: chapters,
    transcript: transcript,
    publishedAt: publishedAt,
    links: links.map((l) => l.toEntity()).toList(),
  );
}

class TranscriptLink {
  final String title;
  final String url;

  TranscriptLink({
    required this.title,
    required this.url,
  });

  factory TranscriptLink.fromJson(Map<String, dynamic> json) => TranscriptLink(
    title: json["title"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
  };

  TranscriptLinkEntity toEntity() => TranscriptLinkEntity(
    title: title,
    url: url,
  );
}
