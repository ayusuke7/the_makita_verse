import '../../../domain/domain.dart';
import '../../../shared/shared.dart';

class PodcastsState extends BaseState {
  final List<PodcastEntity> podcasts;
  final List<PodcastEntity> searchPodcasts;

  const PodcastsState({
    super.status,
    super.error,
    this.podcasts = const [],
    this.searchPodcasts = const [],
  });

  PodcastsState copyWith({
    StateStatus? status,
    String? error,
    List<PodcastEntity>? podcasts,
    List<PodcastEntity>? searchPodcasts,
  }) {
    return PodcastsState(
      status: status ?? this.status,
      error: error ?? this.error,
      podcasts: podcasts ?? this.podcasts,
      searchPodcasts: searchPodcasts ?? this.searchPodcasts,
    );
  }

  @override
  List<Object?> get props => [status, error, podcasts, searchPodcasts];
}
