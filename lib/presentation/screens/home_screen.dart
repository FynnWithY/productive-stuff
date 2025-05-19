import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/playlist_card.dart';
import '../screens/search_screen.dart';
import '../screens/library_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "FFA Music"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            PlaylistCard(title: "Top Hits", onTap: () {}),
            PlaylistCard(title: "Chill Vibes", onTap: () {}),
            PlaylistCard(title: "Workout Mix", onTap: () {}),
            PlaylistCard(title: "Sleepy Tunes", onTap: () {}),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: "Library"),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LibraryScreen()),
            );
          }
        },
      ),
    );
  }
}