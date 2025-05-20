import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/models/song.dart';
import '../../data/services/audio_player_service.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;

  const NowPlayingScreen({Key? key, required this.song}) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayerService _audioPlayerService;

  @override
  void initState() {
    super.initState();
    _audioPlayerService = AudioPlayerService();
    _audioPlayerService.playSong(widget.song);
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3(_audioPlayerService.positionStream,
          _audioPlayerService.durationStream, _audioPlayerService.playerStateStream, (position, duration, state) {
            return PositionData(
              position ?? Duration.zero,
              duration,
              state,
            );
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Now Playing")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(widget.song.albumArtUrl, height: 250, width: 250),
            ),
            const SizedBox(height: 20),
            Text(widget.song.title, style: Theme.of(context).textTheme.titleLarge),
            Text(widget.song.artist, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 30),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final posData = snapshot.data;
                if (posData == null) return const SizedBox();

                return Column(
                  children: [
                    Slider(
                      min: 0,
                      max: posData.duration.inSeconds.toDouble(),
                      value: posData.position.inSeconds.toDouble(),
                      onChanged: (value) {
                        _audioPlayerService.player.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(posData.position.toString().split('.')[0]),
                        Text(posData.duration.toString().split('.')[0]),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 48,
                          icon: const Icon(Icons.skip_previous),
                          onPressed: () {},
                        ),
                        IconButton(
                          iconSize: 64,
                          icon: StreamBuilder<PlayerState>(
                            stream: _audioPlayerService.playerStateStream,
                            builder: (context, snapshot) {
                              final state = snapshot.data?.playing;
                              if (state == null) return const Icon(Icons.play_arrow);
                              return Icon(state ? Icons.pause : Icons.play_arrow);
                            },
                          ),
                          onPressed: () {
                            if (_audioPlayerService.player.playing) {
                              _audioPlayerService.pause();
                            } else {
                              _audioPlayerService.play();
                            }
                          },
                        ),
                        IconButton(
                          iconSize: 48,
                          icon: const Icon(Icons.skip_next),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration duration;
  final PlayerState playerState;

  PositionData(this.position, this.duration, this.playerState);
}