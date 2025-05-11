// lib/auth_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final String clientId = '88fbe8285e3f4b3b9ad35c05f38d02ac';
  final String redirectUri = 'myapp://callback'; // Make sure this matches your AndroidManifest.xml
  final String scopes = 'user-read-private%20playlist-read-private%20streaming';

  Future<void> authenticate(BuildContext context) async {
    final authUrl = Uri.parse(
      'https://accounts.spotify.com/authorize?response_type=token&client_id=$clientId&scope=$scopes&redirect_uri=${Uri.encodeComponent(redirectUri)}',
    );

    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl);
    } else {
      throw 'Could not launch $authUrl';
    }
  }

  Future<String?> getAccessToken(Uri uri) async {
    final queryParams = uri.fragment.split('&');
    final tokenParam = queryParams.firstWhere((param) => param.startsWith('access_token='), orElse: () => '');
    if (tokenParam.isNotEmpty) {
      final accessToken = tokenParam.split('=')[1];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      return accessToken;
    }
    return null;
  }
}