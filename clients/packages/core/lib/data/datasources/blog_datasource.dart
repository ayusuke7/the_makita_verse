import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../data.dart';

abstract interface class BlogDataSource {
  Future<List<RssItemModel>> getRssItems();
}

class BlogDataSourceImpl implements BlogDataSource {
  final http.Client _httpClient;

  BlogDataSourceImpl() : _httpClient = http.Client();

  @override
  Future<List<RssItemModel>> getRssItems() async {
    final url = Uri.parse('https://akitaonrails.com/index.xml');
    final response = await _httpClient.get(url);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes, allowMalformed: true);
      final document = XmlDocument.parse(decodedBody);
      final itemsXml = document.findAllElements('item');
      return itemsXml.map((node) => RssItemModel.fromXmlElement(node)).toList();
    }

    throw Exception('Failed to load posts');
  }
}
