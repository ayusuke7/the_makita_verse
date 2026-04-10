import 'package:xml/xml.dart';

import '../../domain/domain.dart';

class RssItemModel {
  final String title;
  final String link;
  final String description;
  final String pubDate;
  final String guid;
  final String category;

  final String content;

  RssItemModel({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    required this.guid,
    required this.category,
    required this.content,
  });

  String get id => title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();

  factory RssItemModel.fromXmlElement(XmlElement element) {
    return RssItemModel(
      title: _getText(element, 'title'),
      link: _getText(element, 'link'),
      description: _getText(element, 'description'),
      pubDate: _getText(element, 'pubDate'),
      guid: _getText(element, 'guid'),
      category: _getText(element, 'category'),
      content: _getText(element, 'content:encoded'),
    );
  }

  factory RssItemModel.fromJson(Map<String, dynamic> json) {
    return RssItemModel(
      title: json['title'],
      link: json['link'],
      description: json['description'],
      pubDate: json['pubDate'],
      guid: json['guid'],
      category: json['category'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'description': description,
      'pubDate': pubDate,
      'guid': guid,
      'category': category,
      'content': content,
    };
  }

  BlogPostEntity toEntity() {
    return BlogPostEntity(
      id: id,
      title: title,
      link: link,
      description: description,
      pubDate: pubDate,
      guid: guid,
      category: category,
      content: content,
    );
  }

  static String _getText(XmlElement element, String tagName) {
    final node = element.getElement(tagName);
    final value = node?.innerText ?? '';
    return value;
  }
}
