import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:the_makita_verse_app/src/shared/shared.dart';

import '../../../../domain/domain.dart';
import '../../videos.dart';

class TranscriptDetail extends StatelessWidget {
  final TranscriptEntity transcript;
  final VideoEntity? video;

  const TranscriptDetail({
    super.key,
    this.video,
    required this.transcript,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (video != null)
              YTVideoCard(
                video: video!,
                onTap: () {
                  Launch.openLink(transcript.url);
                },
              )
            else
              ListTile(
                title: Text(
                  transcript.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(transcript.publishedAt),
              ),
            Html(
              data: transcript.transcript,
            ),
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required TranscriptEntity transcript,
    VideoEntity? video,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      builder: (context) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(
              child: TranscriptDetail(
                transcript: transcript,
                video: video,
              ),
            ),
          ],
        );
      },
    );
  }
}
