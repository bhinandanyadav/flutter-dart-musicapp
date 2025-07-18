import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../model/song_model.dart';
import 'dart:async';

class EnhancedAudioService {
  static final EnhancedAudioService _instance =
      EnhancedAudioService._internal();
  factory EnhancedAudioService() => _instance;
  EnhancedAudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffleOn = false;
  bool _isRepeatOn = false;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;

  // Stream controllers for compatibility
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  final StreamController<bool> _playingController =
      StreamController<bool>.broadcast();
  final StreamController<double> _volumeController =
      StreamController<double>.broadcast();

  bool _isPlaying = false;
  Timer? _positionTimer;

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isShuffleOn => _isShuffleOn;
  bool get isRepeatOn => _isRepeatOn;
  double get volume => _volume;
  double get playbackSpeed => _playbackSpeed;
  bool get isPlaying => _isPlaying;
  Song? get currentSong =>
      _playlist.isNotEmpty ? _playlist[_currentIndex] : null;

  // Streams
  Stream<Duration?> get positionStream =>
      _positionController.stream.map((d) => d);
  Stream<Duration?> get durationStream =>
      _durationController.stream.map((d) => d);
  Stream<bool> get playingStream => _playingController.stream;
  Stream<double> get volumeStream => _volumeController.stream;

  // Initialize
  Future<void> initialize() async {
    await _audioPlayer.setVolume(_volume);

    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      final isPlaying = state == PlayerState.playing;
      if (_isPlaying != isPlaying) {
        _isPlaying = isPlaying;
        _playingController.add(_isPlaying);
      }

      if (state == PlayerState.completed) {
        _handleTrackCompletion();
      }
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((Duration position) {
      _positionController.add(position);
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      _durationController.add(duration);
    });
  }

  // Enhanced playback controls
  Future<void> play() async {
    if (_playlist.isNotEmpty) {
      await _audioPlayer.resume();
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _audioPlayer.setVolume(_volume);
    _volumeController.add(_volume);
  }

  Future<void> setSpeed(double speed) async {
    _playbackSpeed = speed.clamp(0.5, 2.0);
    await _audioPlayer.setPlaybackRate(_playbackSpeed);
  }

  // Enhanced playlist management
  Future<void> setPlaylist(List<Song> songs, {int initialIndex = 0}) async {
    _playlist = songs;
    _currentIndex = initialIndex.clamp(0, songs.length - 1);
    await _loadCurrentSong();
  }

  Future<void> addToPlaylist(Song song) async {
    _playlist.add(song);
  }

  Future<void> removeFromPlaylist(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _playlist.removeAt(index);
      if (index == _currentIndex) {
        await _loadCurrentSong();
      } else if (index < _currentIndex) {
        _currentIndex--;
      }
    }
  }

  // Navigation controls
  Future<void> skipToNext() async {
    if (_playlist.isEmpty) return;

    if (_isShuffleOn) {
      _currentIndex =
          (DateTime.now().millisecondsSinceEpoch) % _playlist.length;
    } else {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
    }
    await _loadCurrentSong();
    await _audioPlayer.resume();
  }

  Future<void> skipToPrevious() async {
    if (_playlist.isEmpty) return;

    if (_isShuffleOn) {
      _currentIndex =
          (DateTime.now().millisecondsSinceEpoch) % _playlist.length;
    } else {
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    }
    await _loadCurrentSong();
    await _audioPlayer.resume();
  }

  Future<void> skipToIndex(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      await _loadCurrentSong();
      await _audioPlayer.resume();
    }
  }

  // Enhanced shuffle and repeat
  void toggleShuffle() {
    _isShuffleOn = !_isShuffleOn;
  }

  void toggleRepeat() {
    _isRepeatOn = !_isRepeatOn;
  }

  // Private methods
  Future<void> _loadCurrentSong() async {
    if (_playlist.isEmpty) return;

    final song = _playlist[_currentIndex];
    try {
      if (song.audioPath.startsWith('http')) {
        await _audioPlayer.play(UrlSource(song.audioPath));
      } else {
        await _audioPlayer.play(AssetSource(song.audioPath));
      }
    } catch (e) {
      print('Error loading song: $e');
      // Fallback to next song
      await skipToNext();
    }
  }

  void _handleTrackCompletion() {
    if (_isRepeatOn) {
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.resume();
    } else {
      skipToNext();
    }
  }

  // Cleanup
  Future<void> dispose() async {
    _positionTimer?.cancel();
    await _positionController.close();
    await _durationController.close();
    await _playingController.close();
    await _volumeController.close();
    await _audioPlayer.dispose();
  }

  // Audio effects and enhancements
  Future<void> setEqualizer(Map<String, double> eqSettings) async {
    // Placeholder for equalizer implementation
    // This would require additional audio processing plugins
  }

  Future<void> enableCrossfade(bool enabled) async {
    // Placeholder for crossfade implementation
  }

  // Sleep timer
  void setSleepTimer(Duration duration) {
    Future.delayed(duration, () {
      pause();
    });
  }
}
