import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../videos.dart';
import 'components/transcprit_detail.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({super.key});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  final _transcriptViewModel = it.get<TranscriptViewModel>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _transcriptViewModel,
      builder: (context, state, child) {
        if (state.status.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        }

        if (state.status.isError) {
          return Center(
            child: Text('Ops! something went wrong'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: state.transcripts.length,
          itemBuilder: (context, index) {
            final transcript = state.transcripts[index];
            return Card(
              child: ListTile(
                title: Text(
                  transcript.title,
                  softWrap: false,
                ),
                subtitle: Text(transcript.publishedAt),
                onTap: () {
                  final vm = it.get<ChannelViewModel>();
                  final video = vm.getVideo(transcript.videoId);
                  TranscriptDetail.show(
                    context,
                    transcript: transcript,
                    video: video,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
