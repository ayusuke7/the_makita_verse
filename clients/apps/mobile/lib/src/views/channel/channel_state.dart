import 'package:core/core.dart';

class ChannelState extends BaseState {
  final ChannelEntity? channel;
  final List<PlaylistEntity> playlists;

  const ChannelState({
    super.status,
    super.error,
    this.channel,
    this.playlists = const [],
  });

  @override
  List<Object?> get props => [
    status,
    error,
    channel,
    playlists,
  ];

  ChannelState copyWith({
    StateStatus? status,
    String? error,
    ChannelEntity? channel,
    List<PlaylistEntity>? playlists,
  }) {
    return ChannelState(
      status: status ?? this.status,
      error: error ?? this.error,
      channel: channel ?? this.channel,
      playlists: playlists ?? this.playlists,
    );
  }

  List<VideoEntity> get videos {
    if (channel == null) return [];

    return channel!.videos;
  }
}
