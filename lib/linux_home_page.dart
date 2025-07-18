import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'app_colors.dart';
import 'simple_music_app.dart';
import 'model/song_model.dart';

class LinuxHomePage extends StatefulWidget {
  const LinuxHomePage({super.key});

  @override
  State<LinuxHomePage> createState() => _LinuxHomePageState();
}

class _LinuxHomePageState extends State<LinuxHomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _searchController = TextEditingController();

  String _selectedMood = 'All';
  List<Song> _searchResults = [];
  bool _isPlaying = false;
  Song? _currentSong;

  // Mock song data for Linux compatibility
  final List<Song> _allSongs = [
    Song(
      id: '1',
      title: 'Levitating',
      artist: 'Dua Lipa',
      album: 'Future Nostalgia',
      duration: '3:23',
      coverUrl: 'https://via.placeholder.com/300x300/4CD964/FFFFFF?text=DL',
      audioPath: 'Dua-Levitating.mp3',
      genre: 'Pop',
      year: 2020,
    ),
    Song(
      id: '2',
      title: 'Blinding Lights',
      artist: 'The Weeknd',
      album: 'After Hours',
      duration: '3:20',
      coverUrl: 'https://via.placeholder.com/300x300/FF6B6B/FFFFFF?text=TW',
      audioPath: 'Dua-Levitating.mp3', // Using same asset for demo
      genre: 'Pop',
      year: 2019,
    ),
    Song(
      id: '3',
      title: 'Stay',
      artist: 'The Kid LAROI, Justin Bieber',
      album: 'F*CK LOVE 3: OVER YOU',
      duration: '2:21',
      coverUrl: 'https://via.placeholder.com/300x300/9B51E0/FFFFFF?text=KL',
      audioPath: 'Dua-Levitating.mp3', // Using same asset for demo
      genre: 'Hip-Hop',
      year: 2021,
    ),
    Song(
      id: '4',
      title: 'Good 4 U',
      artist: 'Olivia Rodrigo',
      album: 'SOUR',
      duration: '2:58',
      coverUrl: 'https://via.placeholder.com/300x300/00D2FF/FFFFFF?text=OR',
      audioPath: 'Dua-Levitating.mp3', // Using same asset for demo
      genre: 'Pop',
      year: 2021,
    ),
    Song(
      id: '5',
      title: 'Peaches',
      artist: 'Justin Bieber ft. Daniel Caesar, Giveon',
      album: 'Justice',
      duration: '3:18',
      coverUrl: 'https://via.placeholder.com/300x300/4CD964/FFFFFF?text=JB',
      audioPath: 'Dua-Levitating.mp3', // Using same asset for demo
      genre: 'R&B',
      year: 2021,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchResults = _allSongs;
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  List<Song> _getFilteredSongs() {
    List<Song> songs = _allSongs;

    if (_selectedMood != 'All') {
      songs = songs.where((song) => song.genre == _selectedMood).toList();
    }

    return songs;
  }

  void _searchSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = _getFilteredSongs();
      } else {
        _searchResults = _allSongs.where((song) {
          return song.title.toLowerCase().contains(query.toLowerCase()) ||
              song.artist.toLowerCase().contains(query.toLowerCase()) ||
              song.album.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _playSong(Song song) async {
    setState(() {
      _currentSong = song;
    });
    await _audioPlayer.play(AssetSource(song.audioPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildMoodSelector(),
            const SizedBox(height: 20),
            Expanded(child: _buildSongList()),
            if (_currentSong != null) _buildMiniPlayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${_getTimeOfDay()}',
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Music App',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: AppColors.accent,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _searchSongs,
        style: const TextStyle(color: AppColors.primaryText),
        decoration: const InputDecoration(
          hintText: 'Search songs, artists, albums...',
          hintStyle: TextStyle(color: AppColors.secondaryText),
          prefixIcon: Icon(Icons.search, color: AppColors.secondaryText),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = ['All', 'Pop', 'Hip-Hop', 'R&B', 'Rock'];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          final isSelected = _selectedMood == mood;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMood = mood;
                _searchResults = _getFilteredSongs();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                mood,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.background
                      : AppColors.primaryText,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSongList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final song = _searchResults[index];
          return _buildSongItem(song);
        },
      ),
    );
  }

  Widget _buildSongItem(Song song) {
    final isCurrentSong = _currentSong?.id == song.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentSong
            ? AppColors.accent.withValues(alpha: 0.1)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentSong
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: AppColors.background,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: TextStyle(
                    color: isCurrentSong
                        ? AppColors.accent
                        : AppColors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  song.artist,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            song.duration,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _playSong(song),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isCurrentSong && _isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: AppColors.background,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: AppColors.background,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentSong!.title,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _currentSong!.artist,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SimpleMusicApp()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.fullscreen_rounded,
                color: AppColors.background,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}
