import 'package:flutter/material.dart';
import '../model/song_model.dart';
import '../model/playlist_model.dart';
import '../services/enhanced_music_service.dart';
import '../app_colors.dart';
import '../futuristic_player_page.dart';

class EnhancedHomePage extends StatefulWidget {
  const EnhancedHomePage({super.key});

  @override
  State<EnhancedHomePage> createState() => _EnhancedHomePageState();
}

class _EnhancedHomePageState extends State<EnhancedHomePage> {
  final EnhancedMusicService _musicService = EnhancedMusicService();
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();

  int _currentPageIndex = 0;
  String _selectedMood = 'Happy';
  List<Song> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _musicService.initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildMoodSelector(),
            Expanded(
              child: _isSearching ? _buildSearchResults() : _buildMainContent(),
            ),
            _buildMiniPlayer(),
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
                  fontSize: 14,
                ),
              ),
              const Text(
                'Music App',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: AppColors.primaryText,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: AppColors.primaryText,
                ),
                onPressed: () {},
              ),
            ],
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
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 1),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.primaryText),
        decoration: const InputDecoration(
          hintText: 'Search songs, artists, albums...',
          hintStyle: TextStyle(color: AppColors.secondaryText),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: AppColors.secondaryText),
        ),
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
            if (_isSearching) {
              _searchResults = _musicService.searchSongs(value);
            }
          });
        },
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = ['Happy', 'Sad', 'Energetic', 'Chill'];

    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          final isSelected = mood == _selectedMood;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMood = mood;
                _musicService.setCurrentMood(mood);
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accent
                      : AppColors.cardBackground,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  mood,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.background
                        : AppColors.primaryText,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Results (${_searchResults.length})',
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final song = _searchResults[index];
                return _buildSongItem(song);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      children: [
        _buildHomeTab(),
        _buildRecommendationsTab(),
        _buildPlaylistsTab(),
      ],
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Recently Played',
            _musicService.recentlyPlayed,
            isHorizontal: true,
          ),
          _buildSection(
            'Trending Now',
            _musicService.allSongs.take(10).toList(),
            isHorizontal: true,
          ),
          _buildSection(
            'Your Mood: $_selectedMood',
            _musicService.getSongsByMood(_selectedMood),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Recommended for You',
            _musicService.getRecommendations(),
          ),
          _buildSection('Based on Your Likes', _musicService.likedSongs),
        ],
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: const Text(
              'Your Playlists',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ..._musicService.playlists.map(
            (playlist) => _buildPlaylistItem(playlist),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<Song> songs, {
    bool isHorizontal = false,
  }) {
    if (songs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (songs.length > 5)
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(color: AppColors.accent),
                  ),
                ),
            ],
          ),
        ),
        if (isHorizontal)
          _buildHorizontalSongList(songs)
        else
          _buildVerticalSongList(songs),
      ],
    );
  }

  Widget _buildHorizontalSongList(List<Song> songs) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return _buildHorizontalSongCard(song);
        },
      ),
    );
  }

  Widget _buildVerticalSongList(List<Song> songs) {
    return Column(
      children: songs.take(5).map((song) => _buildSongItem(song)).toList(),
    );
  }

  Widget _buildHorizontalSongCard(Song song) {
    return GestureDetector(
      onTap: () => _playSong(song),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withValues(alpha: 0.8),
                    AppColors.accent.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  song.isLiked ? Icons.favorite : Icons.music_note,
                  color: AppColors.primaryText,
                  size: 40,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongItem(Song song) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent.withValues(alpha: 0.8),
              AppColors.accent.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: const Icon(Icons.music_note, color: AppColors.primaryText),
      ),
      title: Text(
        song.title,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.artist,
            style: const TextStyle(color: AppColors.secondaryText),
          ),
          if (song.genre != null)
            Text(
              song.genre!,
              style: TextStyle(
                color: AppColors.accent.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            song.duration,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              song.isLiked ? Icons.favorite : Icons.favorite_border,
              color: song.isLiked ? AppColors.accent : AppColors.secondaryText,
            ),
            onPressed: () => _toggleLike(song),
          ),
        ],
      ),
      onTap: () => _playSong(song),
    );
  }

  Widget _buildPlaylistItem(Playlist playlist) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentPurple.withValues(alpha: 0.8),
              AppColors.accentPurple.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: const Icon(Icons.playlist_play, color: AppColors.primaryText),
      ),
      title: Text(
        playlist.name,
        style: const TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${playlist.songIds.length} songs',
        style: const TextStyle(color: AppColors.secondaryText),
      ),
      trailing: IconButton(
        icon: Icon(
          playlist.isLiked ? Icons.favorite : Icons.favorite_border,
          color: playlist.isLiked ? AppColors.accent : AppColors.secondaryText,
        ),
        onPressed: () {},
      ),
      onTap: () => _playPlaylist(playlist),
    );
  }

  Widget _buildMiniPlayer() {
    return StreamBuilder<Song?>(
      stream: Stream.periodic(
        const Duration(milliseconds: 100),
        (_) => _musicService.currentSong,
      ),
      builder: (context, snapshot) {
        final song = snapshot.data;
        if (song == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FuturisticPlayerPage(),
              ),
            );
          },
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              border: Border(
                top: BorderSide(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.accent.withValues(alpha: 0.8),
                        AppColors.accent.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: AppColors.primaryText,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _musicService.playingStream,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.primaryText,
                      ),
                      onPressed: () => _musicService.playPause(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: AppColors.primaryText,
                  ),
                  onPressed: () => _musicService.skipToNext(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _playSong(Song song) {
    _musicService.playSong(song);
  }

  void _playPlaylist(Playlist playlist) {
    _musicService.playPlaylist(playlist);
  }

  void _toggleLike(Song song) {
    setState(() {
      if (song.isLiked) {
        _musicService.unlikeSong(song);
      } else {
        _musicService.likeSong(song);
      }
    });
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}
