import 'package:flutter/material.dart';
import '../model/song_model.dart';
import '../model/playlist_model.dart';
import '../services/music_service.dart';

class MusicProvider extends ChangeNotifier {
  final MusicService _musicService = MusicService();

  // Getters that pass through to music service
  Song? get currentSong => _musicService.currentSong;
  bool get isPlaying => _musicService.isPlaying;
  bool get isShuffleOn => _musicService.isShuffleOn;
  bool get isRepeatOn => _musicService.isRepeatOn;
  double get volume => _musicService.volume;
  double get currentPosition => _musicService.currentPosition;
  double get totalDuration => _musicService.totalDuration;
  double get progress => _musicService.progress;

  List<Song> getAllSongs() => _musicService.getAllSongs();
  List<Playlist> getAllPlaylists() => _musicService.getAllPlaylists();
  List<Song> getRecentlyPlayed() => _musicService.getRecentlyPlayed();

  // API Methods
  Future<List<Song>> searchSongsFromSpotify(String query) async {
    return await _musicService.searchSongsFromSpotify(query);
  }

  Future<List<Song>> searchSongsFromLastFm(String query) async {
    return await _musicService.searchSongsFromLastFm(query);
  }

  Future<List<Song>> searchSongsFromYouTube(String query) async {
    return await _musicService.searchSongsFromYouTube(query);
  }

  Future<List<Song>> getTrendingSongs() async {
    return await _musicService.getTrendingSongs();
  }

  Future<List<Song>> getTopTracksFromLastFm() async {
    return await _musicService.getTopTracksFromLastFm();
  }

  // Methods that update state and notify listeners
  Future<void> playSong(Song song) async {
    await _musicService.playSong(song);
    notifyListeners();
  }

  Future<void> pausePlayback() async {
    await _musicService.pausePlayback();
    notifyListeners();
  }

  Future<void> resumePlayback() async {
    await _musicService.resumePlayback();
    notifyListeners();
  }

  Future<void> togglePlayback() async {
    await _musicService.togglePlayback();
    notifyListeners();
  }

  Future<void> seekTo(double position) async {
    await _musicService.seekTo(position);
    notifyListeners();
  }

  void nextSong() {
    _musicService.nextSong();
    notifyListeners();
  }

  void previousSong() {
    _musicService.previousSong();
    notifyListeners();
  }

  void toggleShuffle() {
    _musicService.toggleShuffle();
    notifyListeners();
  }

  void toggleRepeat() {
    _musicService.toggleRepeat();
    notifyListeners();
  }

  Future<void> setVolume(double volume) async {
    await _musicService.setVolume(volume);
    notifyListeners();
  }

  Song toggleLike(Song song) {
    final updatedSong = _musicService.toggleLike(song);
    notifyListeners();
    return updatedSong;
  }

  String formatDuration(double seconds) {
    return _musicService.formatDuration(seconds);
  }
}
