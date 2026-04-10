import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';

abstract interface class YoutubeDataSource {
  Future<ChannelModel> getChannel();
  Future<List<PlaylistModel>> getPlaylists();
}

class YoutubeDataSourceImpl implements YoutubeDataSource {
  final http.Client _httpClient;

  final String _baseUrl =
      'https://raw.githubusercontent.com/ayusuke7/the_makita_verse';

  YoutubeDataSourceImpl() : _httpClient = http.Client();

  @override
  Future<ChannelModel> getChannel() async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/main/data/channel/videos.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load channel');
    }

    final body = json.decode(response.body);
    return ChannelModel.fromJson(body);
  }

  @override
  Future<List<PlaylistModel>> getPlaylists() async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/main/data/channel/playlists.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load playlists');
    }

    final playlists = <PlaylistModel>[];
    final body = json.decode(response.body);

    for (var p in body['entries']) {
      playlists.add(PlaylistModel.fromJson(p));
    }

    return playlists;
  }
}
