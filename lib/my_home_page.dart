import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'player_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Top section with greeting and profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What's hot today?",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Text(
                            "Discover new music",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.cardBackground,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppColors.secondaryText,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(
                              color: AppColors.primaryText,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search songs, artists...",
                              hintStyle: TextStyle(
                                color: AppColors.secondaryText,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Popular playlists section
                  Text(
                    "Popular Playlists",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),

            // Horizontal scrollable playlists
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildPlaylistCard(
                      context,
                      "Electronic Mix",
                      "Daft Punk, Avicii, Calvin Harris",
                      AppColors.purpleGradient,
                    ),
                    _buildPlaylistCard(
                      context,
                      "Chill Vibes",
                      "Billie Eilish, Lana Del Rey",
                      AppColors.greenGradient,
                    ),
                    _buildPlaylistCard(
                      context,
                      "Hip Hop Classics",
                      "Kendrick Lamar, J. Cole",
                      AppColors.pinkGradient,
                    ),
                    _buildPlaylistCard(
                      context,
                      "Workout Mix",
                      "Imagine Dragons, Fall Out Boy",
                      AppColors.blueGradient,
                    ),
                  ],
                ),
              ),
            ),

            // Recently played section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 15),
                child: Text(
                  "Recently Played",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),

            // List of songs
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final songList = [
                  {
                    "title": "Blinding Lights",
                    "artist": "The Weeknd",
                    "duration": "3:20",
                  },
                  {
                    "title": "Levitating",
                    "artist": "Dua Lipa",
                    "duration": "3:23",
                  },
                  {
                    "title": "Stay",
                    "artist": "The Kid LAROI, Justin Bieber",
                    "duration": "2:21",
                  },
                  {
                    "title": "Bad Habits",
                    "artist": "Ed Sheeran",
                    "duration": "3:51",
                  },
                  {
                    "title": "Heat Waves",
                    "artist": "Glass Animals",
                    "duration": "3:59",
                  },
                  {
                    "title": "MONTERO",
                    "artist": "Lil Nas X",
                    "duration": "2:18",
                  },
                  {
                    "title": "good 4 u",
                    "artist": "Olivia Rodrigo",
                    "duration": "2:58",
                  },
                  {
                    "title": "Kiss Me More",
                    "artist": "Doja Cat ft. SZA",
                    "duration": "3:29",
                  },
                ];

                if (index >= songList.length) return null;

                return _buildSongListItem(
                  context,
                  songList[index]["title"] ?? "",
                  songList[index]["artist"] ?? "",
                  songList[index]["duration"] ?? "",
                );
              }, childCount: 8),
            ),

            // Space at bottom for mini player
            SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(
    BuildContext context,
    String title,
    String subtitle,
    List<Color> gradientColors,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to player page on tap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PlayerPage()),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15, top: 15, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: gradientColors[0].withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.music_note_rounded,
                color: Colors.white54,
                size: 30,
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  // ignore: deprecated_member_use
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongListItem(
    BuildContext context,
    String title,
    String artist,
    String duration,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to player page on tap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PlayerPage()),
        );
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
                      // ignore: deprecated_member_use
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
              duration,
              style: TextStyle(
                // ignore: deprecated_member_use
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),

            // More options
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white54),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
