import '../../domain/domain.dart';
import '../../shared/shared.dart';

class ChannelState extends BaseState {
  final ChannelEntity? channel;

  const ChannelState({
    super.status,
    super.error,
    this.channel,
  });

  @override
  List<Object?> get props => [
    status,
    error,
    channel,
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
    );
  }

  List<PlaylistEntity> get playlists {
    if (channel == null) return [];

    return channel!.playlists;
  }

  List<VideoEntity> get videos {
    if (channel == null) return [];

    return channel!.videos;
  }
}
