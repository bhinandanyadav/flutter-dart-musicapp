import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'model/song_model.dart';
import 'model/playlist_model.dart';
import 'providers/music_provider.dart';
import 'player_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MusicProvider _musicProvider = MusicProvider();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                Text(
                  "Your Library",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text(
                  "Your music collection",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(25),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.accentGreen,
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              tabs: const [
                Tab(text: "Playlists"),
                Tab(text: "Songs"),
                Tab(text: "Albums"),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPlaylistsTab(),
                _buildSongsTab(),
                _buildAlbumsTab(),
              ],
            ),
          ),

          // Space at bottom for mini player
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    final playlists = _musicProvider.getAllPlaylists();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: playlists.length + 1, // +1 for create playlist button
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildCreatePlaylistItem();
        }

        final playlist = playlists[index - 1];
        return _buildPlaylistItem(playlist);
      },
    );
  }

  Widget _buildCreatePlaylistItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.accentGreen.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.add, color: AppColors.accentGreen),
        ),
        title: const Text(
          "Create Playlist",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onTap: () {
          // Show dialog to create new playlist
          showDialog(
            context: context,
            builder: (context) => _buildCreatePlaylistDialog(),
          );
        },
      ),
    );
  }

  Widget _buildCreatePlaylistDialog() {
    final TextEditingController nameController = TextEditingController();

    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const Text(
        "Create New Playlist",
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: nameController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Playlist name",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.accentGreen),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("CANCEL", style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text(
            "CREATE",
            style: TextStyle(color: AppColors.accentGreen),
          ),
          onPressed: () {
            // In a real app, this would create a new playlist
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Playlist '${nameController.text}' created"),
                backgroundColor: AppColors.accentGreen,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlaylistItem(Playlist playlist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: playlist.gradientColors,
            ),
          ),
          child: const Icon(Icons.music_note, color: Colors.white54),
        ),
        title: Text(
          playlist.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "${playlist.songCount} songs • ${playlist.formattedDuration}",
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white54),
          onPressed: () {},
        ),
        onTap: () {
          // Navigate to playlist details
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlayerPage()),
          );
        },
      ),
    );
  }

  Widget _buildSongsTab() {
    final songs = _musicProvider.getAllSongs();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return _buildSongItem(songs[index]);
      },
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
                  song.artist,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Downloaded indicator
          if (song.isDownloaded)
            const Icon(
              Icons.file_download_done,
              color: AppColors.accentGreen,
              size: 20,
            ),

          // Duration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              song.duration,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ),

          // Like button
          IconButton(
            icon: Icon(
              song.isLiked ? Icons.favorite : Icons.favorite_border,
              color: song.isLiked ? AppColors.accentPink : Colors.white54,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _musicProvider.toggleLike(song);
              });
            },
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

  Widget _buildAlbumsTab() {
    // For demo purposes, create a few mock albums
    final albums = [
      {
        'title': 'After Hours',
        'artist': 'The Weeknd',
        'color': AppColors.accentPink,
      },
      {
        'title': 'Future Nostalgia',
        'artist': 'Dua Lipa',
        'color': AppColors.accentPurple,
      },
      {
        'title': 'Planet Her',
        'artist': 'Doja Cat',
        'color': AppColors.accentBlue,
      },
      {'title': '=', 'artist': 'Ed Sheeran', 'color': AppColors.accentGreen},
      {
        'title': 'SOUR',
        'artist': 'Olivia Rodrigo',
        'color': AppColors.accentPurple,
      },
      {
        'title': 'Dreamland',
        'artist': 'Glass Animals',
        'color': AppColors.accentBlue,
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        return _buildAlbumItem(
          albums[index]['title'] as String,
          albums[index]['artist'] as String,
          (albums[index]['color'] as Color),
        );
      },
    );
  }

  Widget _buildAlbumItem(String title, String artist, Color color) {
    return GestureDetector(
      onTap: () {
        // Navigate to album details
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PlayerPage()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album cover
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.music_note,
                  size: 50,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
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
            artist,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
