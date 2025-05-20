import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../models/song.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player; // 👈 Add this getter

  Future<void> playSong(Song song) async {
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(song.url)));
      await _player.play();
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  void pause() => _player.pause();
  void play() => _player.play();

  Stream<Duration?> get positionStream => _player.positionStream;
  Stream<Duration> get durationStream =>
      _player.durationStream.where((d) => d != null).cast<Duration>();

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  void dispose() {
    _player.dispose();
  }
}