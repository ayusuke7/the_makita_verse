import '../../domain/domain.dart';
import '../../shared/shared.dart';
import 'podcasts_state.dart';

class PodcastsViewModel extends BaseViewModel<PodcastsState> {
  final NewsLetterRepository _newsletterRepository;

  PodcastsViewModel(
    this._newsletterRepository,
  ) : super(PodcastsState());

  void getPodcasts() async {
    if (state.podcasts.isNotEmpty) return;

    emit(state.copyWith(status: StateStatus.loading));
    final result = await _newsletterRepository.getPodcasts();
    result.fold(
      (e) {
        emit(
          state.copyWith(
            status: StateStatus.error,
            error: e.toString(),
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            status: StateStatus.success,
            podcasts: data,
          ),
        );
      },
    );
  }
}
