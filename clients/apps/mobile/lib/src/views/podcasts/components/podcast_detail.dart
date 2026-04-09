import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'audio_player.dart';

class PodcastDetail extends StatefulWidget {
  final PodcastEntity podcast;

  const PodcastDetail({
    super.key,
    required this.podcast,
  });

  @override
  State<PodcastDetail> createState() => _PodcastDetailState();
}

class _PodcastDetailState extends State<PodcastDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () {
              Launch.openLink(widget.podcast.url);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          spacing: 10.0,
          children: [
            ListTile(
              title: Text(
                widget.podcast.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.podcast.subtitle,
                textAlign: TextAlign.center,
              ),
            ),
            Offstage(
              offstage: widget.podcast.audioUrl == null,
              child: CardAudioPlayer(
                audioUrl: widget.podcast.audioUrl!,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: widget.podcast.comments.length,
                itemBuilder: (context, index) {
                  final c = widget.podcast.comments[index];
                  final isMakita = c.name.toLowerCase().contains('akita');
                  return BalonComment(
                    margin: EdgeInsets.only(bottom: 20.0),
                    side: isMakita ? BalonSide.left : BalonSide.right,
                    comment: c.content,
                    avatar: CircleAvatar(
                      backgroundImage: ImageNetworkCache.provider(c.avatar),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'What do you think?',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
