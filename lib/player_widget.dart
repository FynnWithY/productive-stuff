// lib/player_widget.dart
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerWidget extends StatefulWidget {
  final String trackUri;

  PlayerWidget({required this.trackUri});

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializePlayer();
  }

  void _initializePlayer() async {
    // Note: Spotify does not provide direct MP3 URLs. You need to use a service like librespot-java or similar.
    // For demonstration, we'll use a placeholder URL.
    final trackUrl = 'https://p.scdn.co/mp3-preview/your-track-uri'; // Replace with actual track URI
    await _audioPlayer.setUrl(trackUrl);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _audioPlayer.play,
          child: Text('Play'),
        ),
        ElevatedButton(
          onPressed: _audioPlayer.pause,
          child: Text('Pause'),
        ),
        StreamBuilder<PlayerState>(
          stream: _audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return CircularProgressIndicator();
            } else if (!playerState!.playing) {
              return Icon(Icons.play_arrow);
            } else if (processingState != ProcessingState.completed) {
              return Icon(Icons.pause);
            } else {
              return Icon(Icons.replay);
            }
          },
        ),
      ],
    );
  }
}