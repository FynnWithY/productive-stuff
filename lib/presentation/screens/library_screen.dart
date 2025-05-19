import 'package:flutter/material.dart';
import '../widgets/playlist_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Library"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Playlists", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PlaylistCard(title: "Favorites", onTap: () {}),
                  PlaylistCard(title: "Downloads", onTap: () {}),
                  PlaylistCard(title: "Recently Played", onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("History", style: TextStyle(fontSize: 16)),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Recently Played"),
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text("Offline Songs"),
            ),
          ],
        ),
      ),
    );
  }
}