import '../../../shared/shared.dart';
import '../../../domain/domain.dart';
import 'transcript_state.dart';

class TranscriptViewModel extends BaseViewModel<TranscriptState> {
  final BlogRepository _blogRepository;

  TranscriptViewModel(
    this._blogRepository,
  ) : super(const TranscriptState());

  void getTranscripts() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _blogRepository.getTranscripts();
    result.fold(
      (error) => emit(
        state.copyWith(
          status: StateStatus.error,
          error: error.toString(),
        ),
      ),
      (transcripts) => emit(
        state.copyWith(
          status: StateStatus.success,
          transcripts: transcripts,
        ),
      ),
    );
  }

  TranscriptEntity? getTranscript(String videoId) {
    return state.transcripts.where((t) => t.videoId == videoId).firstOrNull;
  }
}
