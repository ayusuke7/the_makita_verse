import 'dart:convert';

import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

abstract interface class BlogDataSource {
  Future<List<RssItemModel>> getRssItems();

  Future<List<RssItemModel>> getSavedRssItems();
  Future<bool> saveRssItem(RssItemModel rssItem);
  Future<bool> removeRssItem(String id);
}

class BlogDataSourceImpl implements BlogDataSource {
  final http.Client _httpClient;
  final SharedPreferences _prefs;

  final String _localRssItemsKey = 'saved_rss_items';

  BlogDataSourceImpl(
    this._prefs,
  ) : _httpClient = http.Client();

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

  @override
  Future<List<RssItemModel>> getSavedRssItems() async {
    final json = _prefs.getString(_localRssItemsKey);
    if (json == null) {
      return [];
    }

    final body = jsonDecode(json) as List<dynamic>;
    return body.map((e) => RssItemModel.fromJson(e)).toList();
  }

  @override
  Future<bool> removeRssItem(String id) async {
    final savedItems = await getSavedRssItems();
    savedItems.removeWhere((item) => item.guid == id);
    await _prefs.setString(_localRssItemsKey, jsonEncode(savedItems));
    return true;
  }

  @override
  Future<bool> saveRssItem(RssItemModel rssItem) async {
    final savedItems = await getSavedRssItems();
    savedItems.add(rssItem);
    await _prefs.setString(_localRssItemsKey, jsonEncode(savedItems));
    return true;
  }
}
