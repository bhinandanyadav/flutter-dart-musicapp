import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/song_model.dart';

class LastFmApiService {
  static const String _baseUrl = 'https://ws.audioscrobbler.com/2.0/';
  static const String _apiKey =
      'YOUR_LASTFM_API_KEY'; // You'll need to add this

  // Search for tracks
  Future<List<Song>> searchTracks(String query, {int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?method=track.search&track=${Uri.encodeComponent(query)}&api_key=$_apiKey&format=json&limit=$limit',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = data['results']['trackmatches']['track'] as List;

        return tracks
            .map(
              (track) => Song(
                id: track['mbid'] ?? track['name'], // Use name as fallback ID
                title: track['name'],
                artist: track['artist'],
                album: track['album'] ?? 'Unknown Album',
                duration: '3:30', // Last.fm doesn't provide duration in search
                coverUrl: track['image'].isNotEmpty
                    ? track['image'][2]['#text'] // Medium size image
                    : '',
                audioPath: '', // Last.fm doesn't provide audio URLs
                isLiked: false,
                isDownloaded: false,
              ),
            )
            .toList();
      }
    } catch (e) {
      print('Error searching Last.fm tracks: $e');
    }
    return [];
  }

  // Get top tracks
  Future<List<Song>> getTopTracks({int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?method=chart.gettoptracks&api_key=$_apiKey&format=json&limit=$limit',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = data['tracks']['track'] as List;

        return tracks
            .map(
              (track) => Song(
                id: track['mbid'] ?? track['name'],
                title: track['name'],
                artist: track['artist']['name'],
                album: track['album']?['title'] ?? 'Unknown Album',
                duration: '3:30',
                coverUrl: track['image'].isNotEmpty
                    ? track['image'][2]['#text']
                    : '',
                audioPath: '',
                isLiked: false,
                isDownloaded: false,
              ),
            )
            .toList();
      }
    } catch (e) {
      print('Error getting top tracks: $e');
    }
    return [];
  }

  // Get artist top tracks
  Future<List<Song>> getArtistTopTracks(String artist, {int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?method=artist.gettoptracks&artist=${Uri.encodeComponent(artist)}&api_key=$_apiKey&format=json&limit=$limit',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = data['toptracks']['track'] as List;

        return tracks
            .map(
              (track) => Song(
                id: track['mbid'] ?? track['name'],
                title: track['name'],
                artist: artist,
                album: track['album']?['title'] ?? 'Unknown Album',
                duration: '3:30',
                coverUrl: track['image'].isNotEmpty
                    ? track['image'][2]['#text']
                    : '',
                audioPath: '',
                isLiked: false,
                isDownloaded: false,
              ),
            )
            .toList();
      }
    } catch (e) {
      print('Error getting artist top tracks: $e');
    }
    return [];
  }

  // Get similar tracks
  Future<List<Song>> getSimilarTracks(
    String artist,
    String track, {
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?method=track.getsimilar&artist=${Uri.encodeComponent(artist)}&track=${Uri.encodeComponent(track)}&api_key=$_apiKey&format=json&limit=$limit',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = data['similartracks']['track'] as List;

        return tracks
            .map(
              (track) => Song(
                id: track['mbid'] ?? track['name'],
                title: track['name'],
                artist: track['artist']['name'],
                album: track['album']?['title'] ?? 'Unknown Album',
                duration: '3:30',
                coverUrl: track['image'].isNotEmpty
                    ? track['image'][2]['#text']
                    : '',
                audioPath: '',
                isLiked: false,
                isDownloaded: false,
              ),
            )
            .toList();
      }
    } catch (e) {
      print('Error getting similar tracks: $e');
    }
    return [];
  }
}
