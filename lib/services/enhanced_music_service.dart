import '../model/song_model.dart';
import '../model/playlist_model.dart';
import 'enhanced_audio_service.dart';

class EnhancedMusicService {
  static final EnhancedMusicService _instance =
      EnhancedMusicService._internal();
  factory EnhancedMusicService() => _instance;
  EnhancedMusicService._internal();

  final EnhancedAudioService _audioService = EnhancedAudioService();

  // Enhanced song library with multiple music sources
  final List<Song> _allSongs = [
    // Popular hits
    Song(
      id: '1',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      album: 'After Hours',
      duration: '3:20',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      isLiked: true,
      genre: 'Pop',
      year: 2020,
    ),
    Song(
      id: '2',
      title: 'Levitating',
      artist: 'Dua Lipa',
      album: 'Future Nostalgia',
      duration: '3:23',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      isLiked: false,
      genre: 'Pop',
      year: 2020,
    ),
    Song(
      id: '3',
      title: 'Stay',
      artist: 'The Kid LAROI, Justin Bieber',
      album: 'F*CK LOVE 3: OVER YOU',
      duration: '2:21',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      isLiked: true,
      genre: 'Pop',
      year: 2021,
    ),
    Song(
      id: '4',
      title: 'Bad Habits',
      artist: 'Ed Sheeran',
      album: '=',
      duration: '3:51',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      isDownloaded: true,
      genre: 'Pop',
      year: 2021,
    ),
    Song(
      id: '5',
      title: 'Heat Waves',
      artist: 'Glass Animals',
      album: 'Dreamland',
      duration: '3:59',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      genre: 'Indie',
      year: 2020,
    ),
    Song(
      id: '6',
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      album: '÷',
      duration: '3:53',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      isLiked: true,
      genre: 'Pop',
      year: 2017,
    ),
    Song(
      id: '7',
      title: 'Watermelon Sugar',
      artist: 'Harry Styles',
      album: 'Fine Line',
      duration: '2:54',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      genre: 'Pop',
      year: 2020,
    ),
    Song(
      id: '8',
      title: 'Circles',
      artist: 'Post Malone',
      album: 'Hollywood\'s Bleeding',
      duration: '3:35',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      genre: 'Hip-Hop',
      year: 2019,
    ),
    Song(
      id: '9',
      title: 'Sunflower',
      artist: 'Post Malone, Swae Lee',
      album: 'Spider-Man: Into the Spider-Verse',
      duration: '2:38',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      isLiked: true,
      genre: 'Hip-Hop',
      year: 2018,
    ),
    Song(
      id: '10',
      title: 'Good 4 U',
      artist: 'Olivia Rodrigo',
      album: 'SOUR',
      duration: '2:58',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      genre: 'Pop',
      year: 2021,
    ),
    Song(
      id: '11',
      title: 'Peaches',
      artist: 'Justin Bieber ft. Daniel Caesar, Giveon',
      album: 'Justice',
      duration: '3:18',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      genre: 'R&B',
      year: 2021,
    ),
    Song(
      id: '12',
      title: 'Industry Baby',
      artist: 'Lil Nas X ft. Jack Harlow',
      album: 'MONTERO',
      duration: '3:32',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      genre: 'Hip-Hop',
      year: 2021,
    ),
    Song(
      id: '13',
      title: 'As It Was',
      artist: 'Harry Styles',
      album: 'Harry\'s House',
      duration: '2:47',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      isLiked: true,
      genre: 'Pop',
      year: 2022,
    ),
    Song(
      id: '14',
      title: 'Anti-Hero',
      artist: 'Taylor Swift',
      album: 'Midnights',
      duration: '3:20',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      genre: 'Pop',
      year: 2022,
    ),
    Song(
      id: '15',
      title: 'Flowers',
      artist: 'Miley Cyrus',
      album: 'Endless Summer Vacation',
      duration: '3:21',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      audioPath: 'assets/Dua-Levitating.mp3',
      genre: 'Pop',
      year: 2023,
    ),
  ];

  // Enhanced playlists
  final List<Playlist> _playlists = [
    Playlist(
      id: '1',
      name: 'Today\'s Top Hits',
      description: 'The most played songs right now',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      songIds: ['1', '2', '3', '13', '14', '15'],
      isLiked: true,
    ),
    Playlist(
      id: '2',
      name: 'Chill Vibes',
      description: 'Relaxing songs for any mood',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      songIds: ['5', '7', '6', '11'],
    ),
    Playlist(
      id: '3',
      name: 'Hip-Hop Hits',
      description: 'Best hip-hop tracks',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      songIds: ['8', '9', '12'],
    ),
    Playlist(
      id: '4',
      name: 'Pop Perfection',
      description: 'Perfect pop songs',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      songIds: ['1', '2', '4', '10', '13', '14', '15'],
    ),
    Playlist(
      id: '5',
      name: 'Liked Songs',
      description: 'Your favorite tracks',
      coverUrl:
          'https://i.scdn.co/image/ab67616d0000b273ef8cf61ffa4edd5e7c3d0827',
      songIds: ['1', '3', '6', '9', '13'],
      isLiked: true,
    ),
  ];

  // User preferences and history
  List<Song> _recentlyPlayed = [];
  List<Song> _likedSongs = [];
  final Map<String, int> _playCount = {};
  String _currentMood = 'Happy';
  final List<String> _favoriteGenres = ['Pop', 'Hip-Hop'];

  // Getters
  List<Song> get allSongs => _allSongs;
  List<Playlist> get playlists => _playlists;
  List<Song> get recentlyPlayed => _recentlyPlayed;
  List<Song> get likedSongs => _likedSongs;
  Map<String, int> get playCount => _playCount;
  String get currentMood => _currentMood;
  List<String> get favoriteGenres => _favoriteGenres;

  // Audio service getters
  EnhancedAudioService get audioService => _audioService;
  Song? get currentSong => _audioService.currentSong;
  bool get isPlaying => _audioService.isPlaying;
  bool get isShuffleOn => _audioService.isShuffleOn;
  bool get isRepeatOn => _audioService.isRepeatOn;
  double get volume => _audioService.volume;
  double get playbackSpeed => _audioService.playbackSpeed;

  // Streams
  Stream<Duration?> get positionStream => _audioService.positionStream;
  Stream<Duration?> get durationStream => _audioService.durationStream;
  Stream<bool> get playingStream => _audioService.playingStream;

  // Initialize
  Future<void> initialize() async {
    await _audioService.initialize();
    _loadUserPreferences();
    _generateLikedSongs();
  }

  // Enhanced playback controls
  Future<void> playPause() async {
    if (isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play();
    }
  }

  Future<void> playSong(Song song) async {
    await _audioService.setPlaylist([song]);
    await _audioService.play();
    _addToRecentlyPlayed(song);
    _incrementPlayCount(song.id);
  }

  Future<void> playPlaylist(Playlist playlist) async {
    final songs = _getSongsFromPlaylist(playlist);
    await _audioService.setPlaylist(songs);
    await _audioService.play();
    if (songs.isNotEmpty) {
      _addToRecentlyPlayed(songs.first);
      _incrementPlayCount(songs.first.id);
    }
  }

  Future<void> addToQueue(Song song) async {
    await _audioService.addToPlaylist(song);
  }

  Future<void> skipToNext() async {
    await _audioService.skipToNext();
    if (currentSong != null) {
      _addToRecentlyPlayed(currentSong!);
      _incrementPlayCount(currentSong!.id);
    }
  }

  Future<void> skipToPrevious() async {
    await _audioService.skipToPrevious();
    if (currentSong != null) {
      _addToRecentlyPlayed(currentSong!);
      _incrementPlayCount(currentSong!.id);
    }
  }

  Future<void> seekTo(Duration position) async {
    await _audioService.seekTo(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioService.setVolume(volume);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await _audioService.setSpeed(speed);
  }

  void toggleShuffle() {
    _audioService.toggleShuffle();
  }

  void toggleRepeat() {
    _audioService.toggleRepeat();
  }

  // Enhanced search with AI-powered suggestions
  List<Song> searchSongs(String query) {
    if (query.isEmpty) return _allSongs;

    final lowerQuery = query.toLowerCase();
    return _allSongs.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery) ||
          song.album.toLowerCase().contains(lowerQuery) ||
          (song.genre?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  // Smart recommendations based on user preferences
  List<Song> getRecommendations() {
    final recommendations = <Song>[];

    // Based on recently played
    for (final song in _recentlyPlayed.take(3)) {
      final similarSongs = _allSongs
          .where((s) => s.genre == song.genre && s.id != song.id)
          .take(2);
      recommendations.addAll(similarSongs);
    }

    // Based on liked songs
    for (final song in _likedSongs.take(2)) {
      final similarSongs = _allSongs
          .where((s) => s.artist == song.artist && s.id != song.id)
          .take(1);
      recommendations.addAll(similarSongs);
    }

    // Based on favorite genres
    for (final genre in _favoriteGenres) {
      final genreSongs = _allSongs.where((s) => s.genre == genre).take(3);
      recommendations.addAll(genreSongs);
    }

    return recommendations.toSet().toList();
  }

  // Mood-based playlists
  List<Song> getSongsByMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return _allSongs
            .where((s) => ['Pop', 'Dance'].contains(s.genre))
            .toList();
      case 'sad':
        return _allSongs
            .where((s) => ['R&B', 'Indie'].contains(s.genre))
            .toList();
      case 'energetic':
        return _allSongs
            .where((s) => ['Hip-Hop', 'Electronic'].contains(s.genre))
            .toList();
      case 'chill':
        return _allSongs
            .where((s) => ['Indie', 'R&B'].contains(s.genre))
            .toList();
      default:
        return _allSongs;
    }
  }

  // User interaction methods
  void likeSong(Song song) {
    final index = _allSongs.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      _allSongs[index] = song.copyWith(isLiked: true);
      if (!_likedSongs.any((s) => s.id == song.id)) {
        _likedSongs.add(song);
      }
    }
  }

  void unlikeSong(Song song) {
    final index = _allSongs.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      _allSongs[index] = song.copyWith(isLiked: false);
      _likedSongs.removeWhere((s) => s.id == song.id);
    }
  }

  void setCurrentMood(String mood) {
    _currentMood = mood;
  }

  // Private helper methods
  void _addToRecentlyPlayed(Song song) {
    _recentlyPlayed.removeWhere((s) => s.id == song.id);
    _recentlyPlayed.insert(0, song);
    if (_recentlyPlayed.length > 20) {
      _recentlyPlayed = _recentlyPlayed.take(20).toList();
    }
  }

  void _incrementPlayCount(String songId) {
    _playCount[songId] = (_playCount[songId] ?? 0) + 1;
  }

  List<Song> _getSongsFromPlaylist(Playlist playlist) {
    return playlist.songIds
        .map((id) => _allSongs.firstWhere((song) => song.id == id))
        .toList();
  }

  void _loadUserPreferences() {
    // Load user preferences from local storage
    // This is a placeholder for actual implementation
  }

  void _generateLikedSongs() {
    _likedSongs = _allSongs.where((song) => song.isLiked).toList();
  }

  // Cleanup
  Future<void> dispose() async {
    await _audioService.dispose();
  }
}
