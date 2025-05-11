// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'package:ffa_music_app/api_service.dart';
import 'package:ffa_music_app/player_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? userProfile;
  Map<String, dynamic>? playlists;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      userProfile = await apiService.getUserProfile();
      final userId = userProfile!['id'];
      playlists = await apiService.getPlaylists(userId);
      setState(() {});
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          if (userProfile != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome, ${userProfile!['display_name']}!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          if (playlists != null)
            Expanded(
              child: ListView.builder(
                itemCount: playlists!['items'].length,
                itemBuilder: (context, index) {
                  final playlist = playlists!['items'][index];
                  return ListTile(
                    title: Text(playlist['name']),
                    subtitle: Text(playlist['uri']),
                    onTap: () {
                      // Navigate to a playlist detail screen or play a track
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistDetailScreen(playlist: playlist),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          if (userProfile == null || playlists == null)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class PlaylistDetailScreen extends StatelessWidget {
  final Map<String, dynamic> playlist;

  PlaylistDetailScreen({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist['name']),
      ),
      body: Column(
        children: [
          PlayerWidget(trackUri: 'your-track-uri'), // Replace with actual track URI
          Expanded(
            child: Center(
              child: Text('Playlist Details'),
            ),
          ),
        ],
      ),
    );
  }
}