import 'package:core/core.dart';

import 'channel_state.dart';

class ChannelViewModel extends BaseViewModel<ChannelState> {
  final YoutubeRepository _youtubeRepository;

  ChannelViewModel(
    this._youtubeRepository,
  ) : super(const ChannelState());

  void getChannel() async {
    emit(state.copyWith(status: StateStatus.loading));

    (await _youtubeRepository.getChannel()).fold(
      (error) => emit(
        state.copyWith(
          status: StateStatus.error,
          error: error.toString(),
        ),
      ),
      (channel) => emit(
        state.copyWith(
          status: StateStatus.success,
          channel: channel,
        ),
      ),
    );
  }

  void getPlaylists() async {
    emit(state.copyWith(status: StateStatus.loading));

    (await _youtubeRepository.getPlaylists()).fold(
      (error) => emit(
        state.copyWith(
          status: StateStatus.error,
          error: error.toString(),
        ),
      ),
      (playlists) => emit(
        state.copyWith(
          status: StateStatus.success,
          playlists: playlists,
        ),
      ),
    );
  }
}
