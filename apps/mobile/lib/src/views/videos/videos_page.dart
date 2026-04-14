import 'package:flutter/material.dart';
import 'package:the_makita_verse_app/src/views/views.dart';

import '../../config/di.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final _transcriptViewModel = it.get<TranscriptViewModel>();
  final _channelViewModel = it.get<ChannelViewModel>();

  final _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _channelViewModel.getChannel();
    _transcriptViewModel.getTranscripts();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        SegmentedButton(
          segments: const [
            ButtonSegment(
              value: 0,
              label: Text('Channel', softWrap: false),
            ),
            ButtonSegment(
              value: 1,
              label: Text('Transcripts', softWrap: false),
            ),
          ],
          selected: {_selectedIndex},
          onSelectionChanged: (value) {
            _pageController.animateToPage(
              value.first,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
            setState(() {
              _selectedIndex = value.first;
            });
          },
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _selectedIndex = page;
              });
            },
            children: [
              ChannelPage(),
              TranscriptPage(),
            ],
          ),
        ),
      ],
    );
  }
}
