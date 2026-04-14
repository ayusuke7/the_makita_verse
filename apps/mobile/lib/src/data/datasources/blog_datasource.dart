import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/config.dart';
import '../models/models.dart';

abstract interface class BlogDataSource {
  Future<List<BlogPostModel>> getBlogPosts();
  Future<List<TranscriptModel>> getTranscripts();
  Future<List<BlogPostModel>> getSavedBlogPosts();
  Future<bool> saveBlogPost(BlogPostModel blogPost);
  Future<bool> removeBlogPost(String id);
}

class BlogDataSourceImpl implements BlogDataSource {
  final http.Client _httpClient;
  final SharedPreferences _prefs;

  final String _localBlogPostsKey = 'saved_blog_posts';
  final String _baseUrl = '${Environment.githubStorageUrl}/data/blog';

  BlogDataSourceImpl(this._prefs) : _httpClient = http.Client();

  @override
  Future<List<TranscriptModel>> getTranscripts() async {
    Logger.log('Fetching transcripts...');

    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/transcripts.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load blog posts');
    }

    final body = json.decode(response.body) as List<dynamic>;
    return body.map((e) => TranscriptModel.fromJson(e)).toList();
  }

  @override
  Future<List<BlogPostModel>> getBlogPosts() async {
    Logger.log('Fetching blog posts...');

    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/posts.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load blog posts');
    }

    final body = json.decode(response.body) as List<dynamic>;
    return body.map((e) => BlogPostModel.fromJson(e)).toList();
  }

  @override
  Future<List<BlogPostModel>> getSavedBlogPosts() async {
    Logger.log('Getting saved blog posts...');

    final json = _prefs.getString(_localBlogPostsKey);
    if (json == null) {
      return [];
    }

    final body = jsonDecode(json) as List<dynamic>;
    return body.map((e) => BlogPostModel.fromJson(e)).toList();
  }

  @override
  Future<bool> removeBlogPost(String id) async {
    Logger.log('Removing blog post...');

    final savedItems = await getSavedBlogPosts();
    savedItems.removeWhere((item) => item.id == id);
    await _prefs.setString(_localBlogPostsKey, jsonEncode(savedItems));
    return true;
  }

  @override
  Future<bool> saveBlogPost(BlogPostModel blogPost) async {
    Logger.log('Saving blog post...');

    final savedItems = await getSavedBlogPosts();
    savedItems.add(blogPost);
    await _prefs.setString(_localBlogPostsKey, jsonEncode(savedItems));
    return true;
  }
}
