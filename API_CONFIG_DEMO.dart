// API Configuration Demo
// Copy this file and rename it to api_config.dart
// Then add your actual API keys

class ApiConfig {
  // Spotify API Configuration
  static const String spotifyClientId = 'YOUR_SPOTIFY_CLIENT_ID';
  static const String spotifyClientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';

  // Last.fm API Configuration
  static const String lastfmApiKey = 'YOUR_LASTFM_API_KEY';

  // YouTube Music (no API key needed for basic features)
  static const bool enableYouTubeMusic = true;

  // API Rate Limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxRequestsPerSecond = 5;
}

// Usage Example:
// 1. Get your API keys from:
//    - Spotify: https://developer.spotify.com/dashboard
//    - Last.fm: https://www.last.fm/api/account/create
//
// 2. Update the constants above with your actual keys
//
// 3. Import this file in your service files:
//    import 'api_config.dart';
//
// 4. Use the keys:
//    static const String _clientId = ApiConfig.spotifyClientId;
//    static const String _apiKey = ApiConfig.lastfmApiKey;
