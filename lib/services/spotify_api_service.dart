import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/song_model.dart';

class SpotifyApiService {
  static const String _baseUrl = 'https://api.spotify.com/v1';
  static const String _clientId =
      'YOUR_SPOTIFY_CLIENT_ID'; // You'll need to add this
  static const String _clientSecret =
      'YOUR_SPOTIFY_CLIENT_SECRET'; // You'll need to add this

  String? _accessToken;
  DateTime? _tokenExpiry;

  // Get access token
  Future<String?> _getAccessToken() async {
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken;
    }

    try {
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_clientId:$_clientSecret'))}',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        _tokenExpiry = DateTime.now().add(
          Duration(seconds: data['expires_in']),
        );
        return _accessToken;
      }
    } catch (e) {
      print('Error getting Spotify access token: $e');
    }
    return null;
  }

  // Search for tracks
  Future<List<Song>> searchTracks(String query, {int limit = 20}) async {
    final token = await _getAccessToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search?q=${Uri.encodeComponent(query)}&type=track&limit=$limit',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = data['tracks']['items'] as List;

        return tracks
            .map(
              (track) => Song(
                id: track['id'],
                title: track['name'],
                artist: (track['artists'] as List).first['name'],
                album: track['album']['name'],
                duration: _formatDuration(track['duration_ms']),
                coverUrl: track['album']['images'].isNotEmpty
                    ? track['album']['images'][0]['url']
                    : '',
                audioPath:
                    track['preview_url'] ??
                    '', // Spotify provides 30-second previews
                isLiked: false,
                isDownloaded: false,
              ),
            )
            .toList();
      }
    } catch (e) {
      print('Error searching Spotify tracks: $e');
    }
    return [];
  }

  // Get featured playlists
  Future<List<Map<String, dynamic>>> getFeaturedPlaylists({
    int limit = 20,
  }) async {
    final token = await _getAccessToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/browse/featured-playlists?limit=$limit'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final playlists = data['playlists']['items'] as List;

        return playlists
            .map(
              (playlist) => {
                'id': playlist['id'],
                'name': playlist['name'],
                'description': playlist['description'],
                'imageUrl': playlist['images'].isNotEmpty
                    ? playlist['images'][0]['url']
                    : '',
                'tracksUrl': playlist['tracks']['href'],
              },
            )
            .toList();
      }
    } catch (e) {
      print('Error getting featured playlists: $e');
    }
    return [];
  }

  // Get playlist tracks
  Future<List<Song>> getPlaylistTracks(String playlistId) async {
    final token = await _getAccessToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/playlists/$playlistId/tracks'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tracks = data['items'] as List;

        return tracks.map((item) {
          final track = item['track'];
          return Song(
            id: track['id'],
            title: track['name'],
            artist: (track['artists'] as List).first['name'],
            album: track['album']['name'],
            duration: _formatDuration(track['duration_ms']),
            coverUrl: track['album']['images'].isNotEmpty
                ? track['album']['images'][0]['url']
                : '',
            audioPath: track['preview_url'] ?? '',
            isLiked: false,
            isDownloaded: false,
          );
        }).toList();
      }
    } catch (e) {
      print('Error getting playlist tracks: $e');
    }
    return [];
  }

  // Get new releases
  Future<List<Song>> getNewReleases({int limit = 20}) async {
    final token = await _getAccessToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/browse/new-releases?limit=$limit'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final albums = data['albums']['items'] as List;

        List<Song> songs = [];
        for (var album in albums) {
          // Get tracks for each album
          final tracksResponse = await http.get(
            Uri.parse('$_baseUrl/albums/${album['id']}/tracks'),
            headers: {'Authorization': 'Bearer $token'},
          );

          if (tracksResponse.statusCode == 200) {
            final tracksData = json.decode(tracksResponse.body);
            final tracks = tracksData['items'] as List;

            for (var track in tracks) {
              songs.add(
                Song(
                  id: track['id'],
                  title: track['name'],
                  artist: (track['artists'] as List).first['name'],
                  album: album['name'],
                  duration: _formatDuration(track['duration_ms']),
                  coverUrl: album['images'].isNotEmpty
                      ? album['images'][0]['url']
                      : '',
                  audioPath: track['preview_url'] ?? '',
                  isLiked: false,
                  isDownloaded: false,
                ),
              );
            }
          }
        }
        return songs;
      }
    } catch (e) {
      print('Error getting new releases: $e');
    }
    return [];
  }

  // Format duration from milliseconds to MM:SS
  String _formatDuration(int milliseconds) {
    final seconds = (milliseconds / 1000).round();
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
