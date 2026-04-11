import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../models/models.dart';

abstract interface class YoutubeDataSource {
  Future<ChannelModel> getChannel();
}

class YoutubeDataSourceImpl implements YoutubeDataSource {
  final http.Client _httpClient;

  final String _baseUrl = '${Environment.githubStorageUrl}/data/channel';

  YoutubeDataSourceImpl() : _httpClient = http.Client();

  @override
  Future<ChannelModel> getChannel() async {
    Logger.log('Fetching channel...');

    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/channel.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load channel');
    }

    final body = json.decode(response.body);
    return ChannelModel.fromJson(body);
  }
}
