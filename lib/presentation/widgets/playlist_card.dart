import 'package:flutter/material.dart';
import '../screens/now_playing_screen.dart'; // 👈 Add this
import '../../../data/models/song.dart';        // 👈 And this

// Dummy song for demo
final dummySong = Song(
  id: "1",
  title: "Sample Song",
  artist: "Artist Name",
  albumArtUrl: "https://i.scdn.co/image/ab67616d0000b273f7db43292a6a99b21f31a35e ",
  url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3 ",
);

class PlaylistCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const PlaylistCard({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NowPlayingScreen(song: dummySong),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(title)),
      ),
    );
  }
}