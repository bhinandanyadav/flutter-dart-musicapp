import 'package:just_audio/just_audio.dart';
import '../model/song_model.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // Streams for UI updates
  Stream<Duration?> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  // Getters
  Duration? get position => _audioPlayer.position;
  Duration? get duration => _audioPlayer.duration;
  PlayerState get playerState => _audioPlayer.playerState;
  bool get playing => _audioPlayer.playing;

  // Initialize audio player
  Future<void> initialize() async {
    try {
      await _audioPlayer.setLoopMode(LoopMode.off);
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  // Play a song
  Future<void> playSong(Song song) async {
    try {
      // Stop current playback
      await _audioPlayer.stop();

      // Set audio source
      if (song.audioPath.startsWith('http')) {
        // For network URLs
        await _audioPlayer.setUrl(song.audioPath);
      } else {
        // For local assets
        await _audioPlayer.setAsset(song.audioPath);
      }

      // Start playback
      await _audioPlayer.play();
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
      await _audioPlayer.play();
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

  // Set loop mode
  Future<void> setLoopMode(LoopMode mode) async {
    try {
      await _audioPlayer.setLoopMode(mode);
    } catch (e) {
      print('Error setting loop mode: $e');
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
