import '../../../domain/domain.dart';
import '../../../shared/shared.dart';
import 'channel_state.dart';

class ChannelViewModel extends BaseViewModel<ChannelState> {
  final ChannelRepository _channelRepository;

  ChannelViewModel(
    this._channelRepository,
  ) : super(const ChannelState());

  void getChannel() async {
    emit(state.copyWith(status: StateStatus.loading));

    (await _channelRepository.getChannel()).fold(
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

  VideoEntity? getVideo(String videoId) {
    return state.channel?.videos.where((v) => v.id == videoId).firstOrNull;
  }
}
