class TranscriptEntity {
  final String url;
  final String videoUrl;
  final String title;
  final String transcript;
  final String publishedAt;
  final List<String> chapters;
  final List<TranscriptLinkEntity> links;

  TranscriptEntity({
    required this.url,
    required this.title,
    required this.videoUrl,
    required this.links,
    required this.chapters,
    required this.transcript,
    required this.publishedAt,
  });

  String get videoId => videoUrl.split('/').last;

  factory TranscriptEntity.fromJson(Map<String, dynamic> json) =>
      TranscriptEntity(
        url: json["url"],
        title: json["title"],
        videoUrl: json["video_url"],
        transcript: json["transcript"],
        publishedAt: json["published_at"],
        links: json["links"] == null
            ? []
            : List<TranscriptLinkEntity>.from(
                json["links"].map((x) => TranscriptLinkEntity.fromJson(x)),
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
}

class TranscriptLinkEntity {
  final String title;
  final String url;

  TranscriptLinkEntity({
    required this.title,
    required this.url,
  });

  factory TranscriptLinkEntity.fromJson(Map<String, dynamic> json) =>
      TranscriptLinkEntity(
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
  };
}
