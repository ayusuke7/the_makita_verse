import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/config.dart';
import '../models/models.dart';

abstract interface class NewsLetterDataSource {
  Future<List<ArticleModel>> getArticles();
  Future<List<PodcastModel>> getPodcasts();

  Future<List<NewsModel>> getSavedNews();
  Future<bool> saveNews(NewsModel news);
  Future<bool> removeNews(String id);
}

class NewsLetterDataSourceImpl implements NewsLetterDataSource {
  final http.Client _httpClient;
  final SharedPreferences _prefs;

  final String _localNewsKey = 'saved_news';

  final String _baseUrl =
      'https://raw.githubusercontent.com/ayusuke7/the_makita_verse/storage';

  NewsLetterDataSourceImpl(this._prefs) : _httpClient = http.Client();

  @override
  Future<List<ArticleModel>> getArticles() async {
    Logger.log('Fetching articles...');

    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/data/articles/index.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load articles');
    }

    final body = json.decode(response.body) as List<dynamic>;
    final articles = <ArticleModel>[];

    for (var a in body) {
      final key = (a['title'] as String).replaceAll(' ', '_').toLowerCase();
      final url = '$_baseUrl/data/articles/${Uri.encodeComponent(key)}.json';
      final res = await _httpClient.get(Uri.parse(url));
      final data = json.decode(res.body);
      final article = ArticleModel.fromJson(data);
      articles.add(article);
    }

    return articles;
  }

  @override
  Future<List<PodcastModel>> getPodcasts() async {
    Logger.log('Fetching podcasts...');

    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/data/podcasts/index.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load podcasts');
    }

    final body = json.decode(response.body) as List<dynamic>;
    final podcasts = <PodcastModel>[];

    for (var a in body) {
      final key = (a['title'] as String).replaceAll(' ', '_').toLowerCase();
      final url = '$_baseUrl/data/podcasts/${Uri.encodeComponent(key)}.json';
      final res = await _httpClient.get(Uri.parse(url));
      final data = json.decode(res.body);
      final podcast = PodcastModel.fromJson(data);
      podcasts.add(podcast);
    }

    return podcasts;
  }

  @override
  Future<List<NewsModel>> getSavedNews() async {
    Logger.log('Getting saved news...');

    final json = _prefs.getString(_localNewsKey);
    if (json == null) {
      return [];
    }

    final body = jsonDecode(json) as List<dynamic>;
    return body.map((e) => NewsModel.fromJson(e)).toList();
  }

  @override
  Future<bool> removeNews(String id) async {
    Logger.log('Removing news...');

    final news = await getSavedNews();
    news.removeWhere((e) => e.id == id);
    return _prefs.setString(_localNewsKey, json.encode(news));
  }

  @override
  Future<bool> saveNews(NewsModel news) async {
    Logger.log('Saving news...');

    final newsList = await getSavedNews();
    if (newsList.any((e) => e.id == news.id)) {
      return true;
    }

    newsList.add(news);
    final data = json.encode(newsList.map((e) => e.toJson()).toList());
    return _prefs.setString(_localNewsKey, data);
  }
}
