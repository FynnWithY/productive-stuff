// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ffa_music_app/auth_service.dart';
import 'package:ffa_music_app/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  Uri? _initialUri;
  bool _isInitialUriHandled = false;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  void initUniLinks() async {
    // Get the initial link
    try {
      _initialUri = await getInitialLink();
    } on PlatformException {
      // Handle exception
    }

    // Listen for incoming links
    uriLinkStream.listen((Uri? uri) {
      if (!mounted || _isInitialUriHandled) return;
      _handleUri(uri);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      print('Error handling link: $err');
    });
  }

  void _handleUri(Uri? uri) async {
    if (uri != null) {
      final accessToken = await authService.getAccessToken(uri);
      if (accessToken != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
    setState(() {
      _isInitialUriHandled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(initialUri: _initialUri),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  final Uri? initialUri;

  LoginScreen({this.initialUri});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    if (widget.initialUri != null) {
      _handleUri(widget.initialUri);
    }
  }

  void _handleUri(Uri? uri) async {
    if (uri != null) {
      final accessToken = await authService.getAccessToken(uri);
      if (accessToken != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Spotify'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => authService.authenticate(context),
          child: Text('Login'),
        ),
      ),
    );
  }
}

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