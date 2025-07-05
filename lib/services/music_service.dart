import '../model/song_model.dart';
import '../model/playlist_model.dart';
import '../app_colors.dart';
import 'audio_service.dart';
import 'spotify_api_service.dart';
import 'lastfm_api_service.dart';
import 'youtube_music_service.dart';
import 'package:just_audio/just_audio.dart';

class MusicService {
  // Singleton pattern
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  final AudioService _audioService = AudioService();
  final SpotifyApiService _spotifyApi = SpotifyApiService();
  final LastFmApiService _lastFmApi = LastFmApiService();
  final YouTubeMusicService _youtubeApi = YouTubeMusicService();

  // Current playing song
  Song? _currentSong;
  final bool _isPlaying = false;
  bool _isShuffleOn = false;
  bool _isRepeatOn = false;
  double _volume = 1.0;
  final double _currentPosition = 0.0;
  final double _totalDuration = 1.0; // Avoid division by zero

  // Getters
  Song? get currentSong => _currentSong;
  bool get isPlaying => _audioService.playing;
  bool get isShuffleOn => _isShuffleOn;
  bool get isRepeatOn => _isRepeatOn;
  double get volume => _volume;
  double get currentPosition =>
      _audioService.position?.inSeconds.toDouble() ?? 0.0;
  double get totalDuration =>
      _audioService.duration?.inSeconds.toDouble() ?? 1.0;
  double get progress => currentPosition / totalDuration;

  // Streams for UI updates
  Stream<Duration?> get positionStream => _audioService.positionStream;
  Stream<Duration?> get durationStream => _audioService.durationStream;
  Stream<PlayerState> get playerStateStream => _audioService.playerStateStream;
  Stream<bool> get playingStream => _audioService.playingStream;

  // Initialize audio service
  Future<void> initialize() async {
    await _audioService.initialize();
  }

  // Mock data with audio paths
  final List<Song> _allSongs = [
    Song(
      id: '1',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      album: 'After Hours',
      duration: '3:20',
      coverUrl: '',
      audioPath: 'assets/Dua-Levitating.mp3', // Using existing asset
      isLiked: true,
    ),
    Song(
      id: '2',
      title: 'Levitating',
      artist: 'Dua Lipa',
      album: 'Future Nostalgia',
      duration: '3:23',
      coverUrl: '',
      audioPath: 'assets/Dua-Levitating.mp3', // Using existing asset
    ),
    Song(
      id: '3',
      title: 'Stay',
      artist: 'The Kid LAROI, Justin Bieber',
      album: 'F*CK LOVE 3: OVER YOU',
      duration: '2:21',
      coverUrl: '',
      audioPath: 'assets/Dua-Levitating.mp3', // Using existing asset
    ),
    Song(
      id: '4',
      title: 'Bad Habits',
      artist: 'Ed Sheeran',
      album: '=',
      duration: '3:51',
      coverUrl: '',
      audioPath: 'assets/Dua-Levitating.mp3', // Using existing asset
      isDownloaded: true,
    ),
    Song(
      id: '5',
      title: 'Heat Waves',
      artist: 'Glass Animals',
      album: 'Dreamland',
      duration: '3:59',
      coverUrl: '',
      audioPath: 'assets/Dua-Levitating.mp3', // Using existing asset
    ),
    Song(
      id: '6',
      title: 'MONTERO',
      artist: 'Lil Nas X',
      album: 'MONTERO',
      duration: '2:18',
      coverUrl: '',
      audioPath: 'assets/Dua-Levitating.mp3', // Using existing asset
      isLiked: true,
    ),
    Song(
      id: '7',
      title: 'good 4 u',
      artist: 'Olivia Rodrigo',
      album: 'SOUR',
      duration: '2:58',
      coverUrl: '',
      audioPath: 'assets/Dua-Levitating.mp3', // Using existing asset
      isDownloaded: true,
    ),
    Song(
      id: '8',
      title: 'Kiss Me More',
      artist: 'Doja Cat ft. SZA',
      album: 'Planet Her',
      duration: '3:29',
      coverUrl: '',
      audioPath: 'assets/Dua-Levitating.mp3', // Using existing asset
    ),
  ];

  final List<Playlist> _playlists = [
    Playlist(
      id: '1',
      name: 'Electronic Mix',
      description: 'Your favorite electronic tracks',
      artistNames: ['Daft Punk', 'Avicii', 'Calvin Harris'],
      songs: [],
      imageUrl: '',
      gradientColors: AppColors.purpleGradient,
      totalDuration: 3600 + 1800, // 1h 30m
    ),
    Playlist(
      id: '2',
      name: 'Chill Vibes',
      description: 'Relaxing tracks for your downtime',
      artistNames: ['Billie Eilish', 'Lana Del Rey', 'Clairo'],
      songs: [],
      imageUrl: '',
      gradientColors: AppColors.greenGradient,
      totalDuration: 4500, // 1h 15m
    ),
    Playlist(
      id: '3',
      name: 'Hip Hop Classics',
      description: 'The best hip hop tracks of all time',
      artistNames: ['Kendrick Lamar', 'J. Cole', 'Drake'],
      songs: [],
      imageUrl: '',
      gradientColors: AppColors.pinkGradient,
      totalDuration: 5400, // 1h 30m
    ),
    Playlist(
      id: '4',
      name: 'Workout Mix',
      description: 'High energy tracks for your workout',
      artistNames: ['Imagine Dragons', 'Fall Out Boy', 'OneRepublic'],
      songs: [],
      imageUrl: '',
      gradientColors: AppColors.blueGradient,
      totalDuration: 3000, // 50m
    ),
  ];

  // Methods
  List<Song> getAllSongs() {
    return List.from(_allSongs);
  }

  // API Methods
  Future<List<Song>> searchSongsFromSpotify(String query) async {
    return await _spotifyApi.searchTracks(query);
  }

  Future<List<Song>> searchSongsFromLastFm(String query) async {
    return await _lastFmApi.searchTracks(query);
  }

  Future<List<Song>> searchSongsFromYouTube(String query) async {
    return await _youtubeApi.searchSongs(query);
  }

  Future<List<Song>> getTrendingSongs() async {
    return await _youtubeApi.getTrendingSongs();
  }

  Future<List<Song>> getTopTracksFromLastFm() async {
    return await _lastFmApi.getTopTracks();
  }

  List<Playlist> getAllPlaylists() {
    return List.from(_playlists);
  }

  List<Song> getRecentlyPlayed() {
    // Return a subset of songs as recently played
    return _allSongs.take(8).toList();
  }

  // Playback control methods
  Future<void> playSong(Song song) async {
    _currentSong = song;
    await _audioService.playSong(song);
  }

  Future<void> pausePlayback() async {
    await _audioService.pause();
  }

  Future<void> resumePlayback() async {
    await _audioService.resume();
  }

  Future<void> togglePlayback() async {
    if (_audioService.playing) {
      await _audioService.pause();
    } else {
      await _audioService.resume();
    }
  }

  Future<void> seekTo(double position) async {
    final duration = Duration(seconds: (position * totalDuration).round());
    await _audioService.seekTo(duration);
  }

  void nextSong() {
    // In a real app, this would play the next song
    int currentIndex = _currentSong != null
        ? _allSongs.indexWhere((song) => song.id == _currentSong!.id)
        : -1;

    if (currentIndex != -1 && currentIndex < _allSongs.length - 1) {
      playSong(_allSongs[currentIndex + 1]);
    } else if (currentIndex == _allSongs.length - 1) {
      // Wrap around to the first song
      playSong(_allSongs[0]);
    }
  }

  void previousSong() {
    // In a real app, this would play the previous song
    int currentIndex = _currentSong != null
        ? _allSongs.indexWhere((song) => song.id == _currentSong!.id)
        : -1;

    if (currentIndex > 0) {
      playSong(_allSongs[currentIndex - 1]);
    } else if (currentIndex == 0) {
      // Wrap around to the last song
      playSong(_allSongs[_allSongs.length - 1]);
    }
  }

  void toggleShuffle() {
    _isShuffleOn = !_isShuffleOn;
    // In a real app, this would enable/disable shuffle mode
  }

  void toggleRepeat() {
    _isRepeatOn = !_isRepeatOn;
    // In a real app, this would cycle through repeat modes
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _audioService.setVolume(_volume);
  }

  Song toggleLike(Song song) {
    final int index = _allSongs.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      final updatedSong = song.copyWith(isLiked: !song.isLiked);
      _allSongs[index] = updatedSong;

      if (_currentSong?.id == song.id) {
        _currentSong = updatedSong;
      }

      return updatedSong;
    }
    return song;
  }

  // Utility methods
  double _parseTimeToSeconds(String time) {
    final parts = time.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return (minutes * 60 + seconds).toDouble();
  }

  String formatDuration(double seconds) {
    final int mins = seconds ~/ 60;
    final int secs = seconds.toInt() % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }
}
