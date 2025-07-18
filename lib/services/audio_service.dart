import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../model/song_model.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration? _duration;

  // Streams for UI updates
  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;
  Stream<Duration> get durationStream => _audioPlayer.onDurationChanged;
  Stream<PlayerState> get playerStateStream =>
      _audioPlayer.onPlayerStateChanged;
  Stream<bool> get playingStream => _audioPlayer.onPlayerStateChanged.map(
    (state) => state == PlayerState.playing,
  );

  // Getters
  Duration? get position =>
      Duration.zero; // audioplayers doesn't have direct position getter
  Duration? get duration => _duration;
  PlayerState get playerState =>
      PlayerState.stopped; // simplified for audioplayers
  bool get playing => false; // will be updated via streams
  // Initialize audio player
  Future<void> initialize() async {
    try {
      // audioplayers doesn't have setLoopMode, we'll handle repeat in the service layer

      // Listen to duration changes
      _audioPlayer.onDurationChanged.listen((duration) {
        _duration = duration;
      });
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  // Play a song
  Future<void> playSong(Song song) async {
    try {
      // Stop current playback
      await _audioPlayer.stop();

      // Set audio source and play
      if (song.audioPath.startsWith('http')) {
        // For network URLs
        await _audioPlayer.play(UrlSource(song.audioPath));
      } else {
        // For local assets
        await _audioPlayer.play(AssetSource(song.audioPath));
      }
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  // Pause playback
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print('Error pausing playback: $e');
    }
  }

  // Resume playback
  Future<void> resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      print('Error resuming playback: $e');
    }
  }

  // Stop playback
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping playback: $e');
    }
  }

  // Seek to position
  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking to position: $e');
    }
  }

  // Set volume
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  // Dispose resources
  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
    } catch (e) {
      print('Error disposing audio player: $e');
    }
  }
}
