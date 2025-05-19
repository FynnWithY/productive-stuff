import 'package:flutter/material.dart';
import 'package:ffa_music/core/theme.dart';
import 'package:ffa_music/presentation/screens/home_screen.dart';

void main() {
  runApp(const FFAMusicApp());
}

class FFAMusicApp extends StatelessWidget {
  const FFAMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFA Music',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
