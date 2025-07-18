import 'package:flutter/material.dart';
import '../model/song_model.dart';
import '../model/playlist_model.dart';
import '../services/enhanced_music_service.dart';

class MusicProvider extends ChangeNotifier {
  final EnhancedMusicService _musicService = EnhancedMusicService();

  Song? _currentSong;
  bool _isPlaying = false;
  bool _isLoading = false;
  List<Song> _recentlyPlayed = [];
  List<Song> _likedSongs = [];
  List<Playlist> _playlists = [];
  String _currentMood = 'Happy';

  // Getters
  EnhancedMusicService get musicService => _musicService;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  List<Song> get recentlyPlayed => _recentlyPlayed;
  List<Song> get likedSongs => _likedSongs;
  List<Playlist> get playlists => _playlists;
  String get currentMood => _currentMood;

  // Initialize
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _musicService.initialize();

    // Listen to music service streams
    _musicService.playingStream.listen((isPlaying) {
      _isPlaying = isPlaying;
      notifyListeners();
    });

    // Update local state
    _updateState();

    _isLoading = false;
    notifyListeners();
  }

  // Update state from music service
  void _updateState() {
    _currentSong = _musicService.currentSong;
    _recentlyPlayed = _musicService.recentlyPlayed;
    _likedSongs = _musicService.likedSongs;
    _playlists = _musicService.playlists;
    _currentMood = _musicService.currentMood;
    notifyListeners();
  }

  // Music control methods
  Future<void> playSong(Song song) async {
    await _musicService.playSong(song);
    _updateState();
  }

  Future<void> playPlaylist(Playlist playlist) async {
    await _musicService.playPlaylist(playlist);
    _updateState();
  }

  Future<void> playPause() async {
    await _musicService.playPause();
    _updateState();
  }

  Future<void> skipToNext() async {
    await _musicService.skipToNext();
    _updateState();
  }

  Future<void> skipToPrevious() async {
    await _musicService.skipToPrevious();
    _updateState();
  }

  Future<void> seekTo(Duration position) async {
    await _musicService.seekTo(position);
  }

  Future<void> setVolume(double volume) async {
    await _musicService.setVolume(volume);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await _musicService.setPlaybackSpeed(speed);
  }

  void toggleShuffle() {
    _musicService.toggleShuffle();
    notifyListeners();
  }

  void toggleRepeat() {
    _musicService.toggleRepeat();
    notifyListeners();
  }

  // User interaction methods
  void likeSong(Song song) {
    _musicService.likeSong(song);
    _updateState();
  }

  void unlikeSong(Song song) {
    _musicService.unlikeSong(song);
    _updateState();
  }

  void setCurrentMood(String mood) {
    _currentMood = mood;
    _musicService.setCurrentMood(mood);
    notifyListeners();
  }

  // Search
  List<Song> searchSongs(String query) {
    return _musicService.searchSongs(query);
  }

  // Recommendations
  List<Song> getRecommendations() {
    return _musicService.getRecommendations();
  }

  List<Song> getSongsByMood(String mood) {
    return _musicService.getSongsByMood(mood);
  }

  @override
  void dispose() {
    _musicService.dispose();
    super.dispose();
  }
}
