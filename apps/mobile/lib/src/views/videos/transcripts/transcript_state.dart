import '../../../shared/shared.dart';
import '../../../domain/domain.dart';

class TranscriptState extends BaseState {
  final List<TranscriptEntity> transcripts;

  const TranscriptState({
    super.status,
    super.error,
    this.transcripts = const [],
  });

  @override
  List<Object?> get props => [status, error, transcripts];

  TranscriptState copyWith({
    StateStatus? status,
    String? error,
    List<TranscriptEntity>? transcripts,
  }) {
    return TranscriptState(
      status: status ?? this.status,
      error: error ?? this.error,
      transcripts: transcripts ?? this.transcripts,
    );
  }
}
