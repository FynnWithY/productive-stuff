import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.deepPurple,
    appBarTheme: const AppBarTheme(color: Colors.deepPurple),
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.light)
        .copyWith(secondary: Colors.deepPurpleAccent),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,
    appBarTheme: const AppBarTheme(color: Colors.black87),
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
        .copyWith(secondary: Colors.deepPurpleAccent),
  );
}