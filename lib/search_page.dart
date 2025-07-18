import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'model/song_model.dart';
import 'providers/music_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final MusicProvider _musicProvider = MusicProvider();

  List<Song> _allSongs = [];
  List<Song> _filteredSongs = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _allSongs = _musicProvider.getAllSongs();
    _filteredSongs = [];
  }

  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = [];
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredSongs = _allSongs
            .where(
              (song) =>
                  song.title.toLowerCase().contains(query.toLowerCase()) ||
                  song.artist.toLowerCase().contains(query.toLowerCase()) ||
                  song.album.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search header
                Text(
                  "Search",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  "Find your favorite songs",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),

                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.secondaryText),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: AppColors.primaryText),
                          decoration: InputDecoration(
                            hintText: "Artists, songs, or albums",
                            hintStyle: TextStyle(
                              color: AppColors.secondaryText,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          onChanged: _filterSongs,
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.secondaryText,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _filteredSongs = [];
                              _isSearching = false;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search results
          Expanded(
            child: _isSearching
                ? _filteredSongs.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _filteredSongs.length,
                          itemBuilder: (context, index) {
                            return _buildSongListItem(
                              context,
                              _filteredSongs[index],
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 70,
                                color: AppColors.secondaryText.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "No results found",
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Try searching for something else",
                                style: TextStyle(
                                  color: AppColors.secondaryText.withValues(alpha: 
                                    0.7,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                : _buildSearchSuggestions(),
          ),

          // Bottom space for mini player
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Recent Searches",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildSearchChip("The Weeknd"),
              _buildSearchChip("Pop"),
              _buildSearchChip("Dance Hits"),
              _buildSearchChip("Workout Mix"),
              _buildSearchChip("Billie Eilish"),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "Browse Categories",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 15),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                _buildCategoryCard("Hip Hop", AppColors.purpleGradient),
                _buildCategoryCard("Pop", AppColors.greenGradient),
                _buildCategoryCard("Rock", AppColors.pinkGradient),
                _buildCategoryCard("Electronic", AppColors.blueGradient),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchController.text = label;
          _filterSongs(label);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(color: AppColors.primaryText, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, List<Color> gradientColors) {
    return GestureDetector(
      onTap: () {
        // Handle category tap
        setState(() {
          _searchController.text = title;
          _filterSongs(title);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongListItem(BuildContext context, Song song) {
    return GestureDetector(
      onTap: () {
        _musicProvider.playSong(song);
      },
      child: Container(
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
              child: const Icon(Icons.music_note, color: Colors.white54),
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
                    "${song.artist} • ${song.album}",
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
            Text(
              song.duration,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),

            // More options
            IconButton(
              icon: Icon(
                song.isLiked ? Icons.favorite : Icons.favorite_border,
                color: song.isLiked ? AppColors.accentPink : Colors.white54,
              ),
              onPressed: () {
                _musicProvider.toggleLike(song);
                setState(() {
                  // Update the UI
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
