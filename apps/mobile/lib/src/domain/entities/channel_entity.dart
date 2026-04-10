class ChannelEntity {
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
  final List<VideoEntity> videos;
  final List<ThumbnailEntity> thumbnails;
  final List<PlaylistEntity> playlists;

  ChannelEntity({
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

  ThumbnailEntity get thumbnail => thumbnails.first;
}

class VideoEntity {
  final String id;
  final String url;
  final String title;
  final double duration;
  final int viewCount;
  final String description;
  final List<ThumbnailEntity> thumbnails;

  VideoEntity({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
    required this.duration,
    required this.thumbnails,
    required this.viewCount,
  });

  ThumbnailEntity get thumbnail => thumbnails.first;
}

class ThumbnailEntity {
  final String url;
  final int height;
  final int width;

  ThumbnailEntity({
    required this.url,
    required this.height,
    required this.width,
  });
}

class PlaylistEntity {
  final String id;
  final String url;
  final String title;
  final List<ThumbnailEntity> thumbnails;

  PlaylistEntity({
    required this.id,
    required this.url,
    required this.title,
    required this.thumbnails,
  });

  ThumbnailEntity get thumbnail => thumbnails.first;
}
