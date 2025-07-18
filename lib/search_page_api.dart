import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'model/song_model.dart';
import 'providers/music_provider.dart';

class SearchPageApi extends StatefulWidget {
  const SearchPageApi({super.key});

  @override
  SearchPageApiState createState() => SearchPageApiState();
}

class SearchPageApiState extends State<SearchPageApi> {
  final TextEditingController _searchController = TextEditingController();
  final MusicProvider _musicProvider = MusicProvider();

  List<Song> _searchResults = [];
  List<Song> _trendingSongs = [];
  List<Song> _topTracks = [];
  bool _isLoading = false;
  String _selectedApi = 'YouTube'; // Default API

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    try {
      // Load trending songs and top tracks
      final trending = await _musicProvider.getTrendingSongs();
      final topTracks = await _musicProvider.getTopTracksFromLastFm();

      setState(() {
        _trendingSongs = trending;
        _topTracks = topTracks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading initial data: $e');
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      List<Song> results = [];

      switch (_selectedApi) {
        case 'Spotify':
          results = await _musicProvider.searchSongsFromSpotify(query);
          break;
        case 'Last.fm':
          results = await _musicProvider.searchSongsFromLastFm(query);
          break;
        case 'YouTube':
          results = await _musicProvider.searchSongsFromYouTube(query);
          break;
      }

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error searching: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search Music",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 20),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search for songs, artists, or albums...",
                      hintStyle: TextStyle(
                        // ignore: deprecated_member_use
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white54,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white54,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchResults = []);
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length >= 2) {
                        _performSearch(value);
                      } else {
                        setState(() => _searchResults = []);
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // API Selector
                Row(
                  children: [
                    Text(
                      "Search from: ",
                      // ignore: deprecated_member_use
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedApi,
                        dropdownColor: AppColors.cardBackground,
                        style: const TextStyle(color: Colors.white),
                        underline: Container(),
                        items: ['YouTube', 'Spotify', 'Last.fm'].map((
                          String api,
                        ) {
                          return DropdownMenuItem<String>(
                            value: api,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Text(api),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _selectedApi = newValue);
                            if (_searchController.text.isNotEmpty) {
                              _performSearch(_searchController.text);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentGreen,
                    ),
                  )
                : _searchResults.isNotEmpty
                ? _buildSearchResults()
                : _buildDefaultContent(),
          ),
          // Space at bottom for mini player
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _searchResults.length + 1, // +1 for bottom spacing
      itemBuilder: (context, index) {
        if (index == _searchResults.length) {
          return const SizedBox(height: 20); // Bottom spacing
        }
        return _buildSongItem(_searchResults[index]);
      },
    );
  }

  Widget _buildDefaultContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Trending Songs
        if (_trendingSongs.isNotEmpty) ...[
          _buildSectionHeader("Trending Songs"),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _trendingSongs.length,
              itemBuilder: (context, index) {
                return _buildTrendingSongCard(_trendingSongs[index]);
              },
            ),
          ),
          const SizedBox(height: 30),
        ],

        // Top Tracks
        if (_topTracks.isNotEmpty) ...[
          _buildSectionHeader("Top Tracks"),
          ..._topTracks.map((song) => _buildSongItem(song)),
          const SizedBox(height: 20), // Extra space at bottom
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTrendingSongCard(Song song) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album cover
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [AppColors.accentBlue, AppColors.accentPurple],
                ),
              ),
              child: song.coverUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        song.coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.music_note,
                            color: Colors.white54,
                            size: 50,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.music_note,
                      color: Colors.white54,
                      size: 50,
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            song.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            song.artist,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSongItem(Song song) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Album cover
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [AppColors.accentBlue, AppColors.accentPurple],
              ),
            ),
            child: song.coverUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.music_note,
                          color: Colors.white54,
                        );
                      },
                    ),
                  )
                : const Icon(Icons.music_note, color: Colors.white54),
          ),

          const SizedBox(width: 15),

          // Song info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  song.artist,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Duration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              song.duration,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ),

          // Play button
          IconButton(
            icon: const Icon(
              Icons.play_arrow,
              color: AppColors.accentGreen,
              size: 24,
            ),
            onPressed: () async {
              await _musicProvider.playSong(song);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
