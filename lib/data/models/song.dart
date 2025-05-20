class Song {
  final String id;
  final String title;
  final String artist;
  final String albumArtUrl;
  final String url; // direct link to audio file

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArtUrl,
    required this.url,
  });
}