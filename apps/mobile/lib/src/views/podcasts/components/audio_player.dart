import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CardAudioPlayer extends StatefulWidget {
  final String audioUrl;

  const CardAudioPlayer({
    super.key,
    required this.audioUrl,
  });

  @override
  State<CardAudioPlayer> createState() => _CardAudioPlayerState();
}

class _CardAudioPlayerState extends State<CardAudioPlayer> {
  final player = AudioPlayer();

  double get duration {
    if (player.duration == null) return 0.0;
    return player.position.inSeconds.toDouble();
  }

  double get maxDuration {
    if (player.duration == null) return 0.0;
    return player.duration!.inSeconds.toDouble();
  }

  @override
  void initState() {
    super.initState();
    player.setUrl(widget.audioUrl);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (player.playing) {
                  player.pause();
                } else {
                  player.play();
                }
              });
            },
            iconSize: 34.0,
            icon: Icon(player.playing ? Icons.pause_circle : Icons.play_circle),
          ),
          Flexible(
            child: Slider(
              value: duration,
              max: maxDuration,
              label: 'Listen',
              thumbColor: Colors.white,
              activeColor: Colors.yellow,
              inactiveColor: Colors.white.withAlpha(50),
              onChanged: (value) {
                setState(() {
                  player.seek(Duration(seconds: value.toInt()));
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
