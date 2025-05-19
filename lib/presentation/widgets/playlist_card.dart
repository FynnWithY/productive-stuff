import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const PlaylistCard({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(title)),
      ),
    );
  }
}
