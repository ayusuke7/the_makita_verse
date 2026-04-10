import '../../domain/domain.dart';

class ChannelModel {
  final String id;
  final String channel;
  final String title;
  final int channelFollowerCount;
  final String description;
  final String uploaderId;
  final String uploaderUrl;
  final int playlistCount;
  final String uploader;
  final String channelUrl;
  final List<String> tags;
  final List<VideoModel> videos;
  final List<ThumbnailModel> thumbnails;
  final List<PlaylistModel> playlists;

  ChannelModel({
    required this.id,
    required this.channel,
    required this.title,
    required this.channelFollowerCount,
    required this.description,
    required this.tags,
    required this.videos,
    required this.thumbnails,
    required this.uploaderId,
    required this.uploaderUrl,
    required this.playlistCount,
    required this.uploader,
    required this.channelUrl,
    required this.playlists,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) => ChannelModel(
    id: json['id'],
    channel: json['channel'],
    title: json['title'],
    channelFollowerCount: json['channel_follower_count'],
    description: json['description'],
    tags: json['tags'] == null
        ? []
        : (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    videos: json['entries'] == null
        ? []
        : (json['entries'] as List<dynamic>)
              .map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    thumbnails: json['thumbnails'] == null
        ? []
        : (json['thumbnails'] as List<dynamic>)
              .map((e) => ThumbnailModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    uploaderId: json['uploader_id'],
    uploaderUrl: json['uploader_url'],
    playlistCount: json['playlist_count'],
    uploader: json['uploader'],
    channelUrl: json['channel_url'],
    playlists: json['playlists'] == null
        ? []
        : (json['playlists'] as List<dynamic>)
              .map((e) => PlaylistModel.fromJson(e as Map<String, dynamic>))
              .toList(),
  );

  ChannelEntity toEntity() => ChannelEntity(
    id: id,
    channel: channel,
    title: title,
    channelFollowerCount: channelFollowerCount,
    description: description,
    tags: tags,
    uploaderId: uploaderId,
    uploaderUrl: uploaderUrl,
    playlistCount: playlistCount,
    uploader: uploader,
    channelUrl: channelUrl,
    videos: videos.map((e) => e.toEntity()).toList(),
    thumbnails: thumbnails.map((e) => e.toEntity()).toList(),
    playlists: playlists.map((e) => e.toEntity()).toList(),
  );
}

class VideoModel {
  final String id;
  final String url;
  final String title;
  final double duration;
  final int viewCount;
  final String description;
  final List<ThumbnailModel> thumbnails;

  VideoModel({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
    required this.duration,
    required this.thumbnails,
    required this.viewCount,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    id: json['id'],
    url: json['url'],
    title: json['title'],
    description: json['description'],
    duration: json['duration'],
    viewCount: json['view_count'],
    thumbnails: json['thumbnails'] == null
        ? []
        : (json['thumbnails'] as List<dynamic>)
              .map((e) => ThumbnailModel.fromJson(e as Map<String, dynamic>))
              .toList(),
  );

  VideoEntity toEntity() => VideoEntity(
    id: id,
    url: url,
    title: title,
    description: description,
    duration: duration,
    viewCount: viewCount,
    thumbnails: thumbnails.map((e) => e.toEntity()).toList(),
  );
}

class ThumbnailModel {
  final String url;
  final int height;
  final int width;

  ThumbnailModel({
    required this.url,
    required this.height,
    required this.width,
  });

  factory ThumbnailModel.fromJson(Map<String, dynamic> json) => ThumbnailModel(
    url: json['url'],
    height: json['height'] ?? 320,
    width: json['width'] ?? 480,
  );

  ThumbnailEntity toEntity() => ThumbnailEntity(
    url: url,
    height: height,
    width: width,
  );
}

class PlaylistModel {
  final String id;
  final String url;
  final String title;
  final List<ThumbnailModel> thumbnails;

  PlaylistModel({
    required this.id,
    required this.url,
    required this.title,
    required this.thumbnails,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
    id: json['id'],
    url: json['url'],
    title: json['title'],
    thumbnails: json['thumbnails'] == null
        ? []
        : (json['thumbnails'] as List<dynamic>)
              .map((e) => ThumbnailModel.fromJson(e as Map<String, dynamic>))
              .toList(),
  );

  PlaylistEntity toEntity() => PlaylistEntity(
    id: id,
    url: url,
    title: title,
    thumbnails: thumbnails.map((e) => e.toEntity()).toList(),
  );
}
