import '../../data/data.dart';

class BlogPostEntity {
  final String id;
  final String title;
  final String url;
  final String content;
  final String publishedAt;

  BlogPostEntity({
    required this.id,
    required this.title,
    required this.url,
    required this.content,
    required this.publishedAt,
  });

  List<String> get splitDate {
    // date format: "11 de abril de 2006"
    return publishedAt.split(' ')..removeWhere((e) => e == 'de');
  }

  String get day => splitDate[0];

  String get month => splitDate[1];

  String get year => splitDate[2];

  BlogPostModel toModel() {
    return BlogPostModel(
      url: url,
      title: title,
      content: content,
      publishedAt: publishedAt,
    );
  }
}
