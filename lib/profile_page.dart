import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'model/song_model.dart';
import 'model/playlist_model.dart';
import 'services/enhanced_music_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final EnhancedMusicService _musicService = EnhancedMusicService();
  late TabController _tabController;

  // User data
  String userName = "Abhinandan Yadav";
  String userEmail = "abhinandan.yadav@example.com";
  String userBio =
      "Music enthusiast • Playlist curator • Love discovering new artists";
  bool isPremiumUser = true;
  bool isDataSaverOn = false;
  bool isDarkModeOn = true;
  bool isNotificationsOn = true;

  // User statistics
  int totalSongs = 0;
  int totalPlaylists = 0;
  int totalListeningTime = 0; // in minutes
  int followersCount = 162;
  int followingCount = 87;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    setState(() {
      totalSongs = _musicService.allSongs.length;
      totalPlaylists = _musicService.playlists.length;
      totalListeningTime = _musicService.playCount.values.fold(
        0,
        (sum, count) => sum + (count * 3),
      ); // Estimated
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Profile Header
          _buildProfileHeader(),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(colors: AppColors.greenGradient),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.secondaryText,
              tabs: const [
                Tab(text: "Overview"),
                Tab(text: "Activity"),
                Tab(text: "Settings"),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildActivityTab(),
                _buildSettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentBlue, AppColors.accentPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture and Edit Button
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.accentPurple,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _editProfile,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGreen,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // User Name and Premium Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isPremiumUser) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "PREMIUM",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 5),

          // User Email
          Text(
            userEmail,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 10),

          // User Bio
          Text(
            userBio,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 20),

          // Social Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialStat("Songs", totalSongs.toString()),
              _buildSocialStat("Playlists", totalPlaylists.toString()),
              _buildSocialStat("Followers", followersCount.toString()),
              _buildSocialStat("Following", followingCount.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialStat(String label, String value) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Handle tap based on stat type
      },
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Listening Statistics
          _buildStatisticsCard(),

          const SizedBox(height: 20),

          // Recent Achievements
          _buildAchievementsCard(),

          const SizedBox(height: 20),

          // Top Genres
          _buildTopGenresCard(),

          const SizedBox(height: 20),

          // Listening Habits
          _buildListeningHabitsCard(),

          const SizedBox(height: 100), // Space for mini player
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentPink, AppColors.accentPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Listening Statistics",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                "Total Time",
                "${totalListeningTime ~/ 60}h ${totalListeningTime % 60}m",
              ),
              _buildStatItem("This Week", "8h 32m"),
              _buildStatItem("Average", "1h 15m/day"),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Most Played", "Levitating"),
              _buildStatItem("Skip Rate", "12%"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildAchievementsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Achievements",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildAchievementItem(
            Icons.music_note,
            "Music Explorer",
            "Listened to 50 different artists",
            AppColors.accentGreen,
          ),
          _buildAchievementItem(
            Icons.playlist_play,
            "Playlist Master",
            "Created 10 playlists",
            AppColors.accentBlue,
          ),
          _buildAchievementItem(
            Icons.favorite,
            "Song Lover",
            "Liked 100 songs",
            AppColors.accentPink,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopGenresCard() {
    final genres = [
      {"name": "Pop", "percentage": 0.45, "color": AppColors.accentGreen},
      {"name": "Hip-Hop", "percentage": 0.30, "color": AppColors.accentBlue},
      {"name": "R&B", "percentage": 0.15, "color": AppColors.accentPink},
      {"name": "Indie", "percentage": 0.10, "color": AppColors.accentPurple},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Genres",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          ...genres.map(
            (genre) => _buildGenreItem(
              genre["name"] as String,
              genre["percentage"] as double,
              genre["color"] as Color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreItem(String name, double percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                name.substring(0, 1),
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${(percentage * 100).toInt()}%",
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListeningHabitsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Listening Habits",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildHabitItem("Most Active Time", "8:00 PM - 10:00 PM"),
          _buildHabitItem("Favorite Day", "Saturday"),
          _buildHabitItem("Average Session", "25 minutes"),
          _buildHabitItem("Preferred Device", "Mobile"),
        ],
      ),
    );
  }

  Widget _buildHabitItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recently Played
          _buildRecentlyPlayedCard(),

          const SizedBox(height: 20),

          // Liked Songs
          _buildLikedSongsCard(),

          const SizedBox(height: 20),

          // Created Playlists
          _buildCreatedPlaylistsCard(),

          const SizedBox(height: 100), // Space for mini player
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayedCard() {
    final recentSongs = _musicService.recentlyPlayed.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recently Played",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(color: AppColors.accentGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (recentSongs.isEmpty)
            const Center(
              child: Text(
                "No recent activity",
                style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
              ),
            )
          else
            ...recentSongs.map((song) => _buildSongTile(song)),
        ],
      ),
    );
  }

  Widget _buildLikedSongsCard() {
    final likedSongs = _musicService.likedSongs.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Liked Songs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(color: AppColors.accentGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (likedSongs.isEmpty)
            const Center(
              child: Text(
                "No liked songs yet",
                style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
              ),
            )
          else
            ...likedSongs.map((song) => _buildSongTile(song)),
        ],
      ),
    );
  }

  Widget _buildCreatedPlaylistsCard() {
    final playlists = _musicService.playlists.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Playlists",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(color: AppColors.accentGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (playlists.isEmpty)
            const Center(
              child: Text(
                "No playlists created yet",
                style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
              ),
            )
          else
            ...playlists.map((playlist) => _buildPlaylistTile(playlist)),
        ],
      ),
    );
  }

  Widget _buildSongTile(Song song) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(colors: AppColors.blueGradient),
            ),
            child: const Icon(Icons.music_note, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
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
          IconButton(
            onPressed: () => _musicService.playSong(song),
            icon: const Icon(Icons.play_arrow, color: AppColors.accentGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(Playlist playlist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(colors: AppColors.purpleGradient),
            ),
            child: const Icon(Icons.playlist_play, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${playlist.songIds.length} songs",
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _musicService.playPlaylist(playlist),
            icon: const Icon(Icons.play_arrow, color: AppColors.accentGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Settings
          _buildAccountSettingsCard(),

          const SizedBox(height: 20),

          // App Settings
          _buildAppSettingsCard(),

          const SizedBox(height: 20),

          // Support
          _buildSupportCard(),

          const SizedBox(height: 100), // Space for mini player
        ],
      ),
    );
  }

  Widget _buildAccountSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildSettingsItem(
            icon: Icons.person,
            title: "Personal Information",
            subtitle: "Update your profile details",
            onTap: _editProfile,
          ),
          _buildSettingsItem(
            icon: Icons.email,
            title: "Email Settings",
            subtitle: "Change email and notifications",
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.lock,
            title: "Privacy & Security",
            subtitle: "Manage your privacy settings",
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.credit_card,
            title: "Subscription",
            subtitle: isPremiumUser ? "Premium Active" : "Upgrade to Premium",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "App Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildSettingsItem(
            icon: Icons.notifications,
            title: "Notifications",
            subtitle: "Manage your notifications",
            trailing: Switch(
              value: isNotificationsOn,
              activeColor: AppColors.accentGreen,
              onChanged: (value) {
                setState(() {
                  isNotificationsOn = value;
                });
              },
            ),
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.data_usage,
            title: "Data Saver",
            subtitle: "Reduce data usage",
            trailing: Switch(
              value: isDataSaverOn,
              activeColor: AppColors.accentGreen,
              onChanged: (value) {
                setState(() {
                  isDataSaverOn = value;
                });
              },
            ),
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            subtitle: "Toggle dark theme",
            trailing: Switch(
              value: isDarkModeOn,
              activeColor: AppColors.accentGreen,
              onChanged: (value) {
                setState(() {
                  isDarkModeOn = value;
                });
              },
            ),
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.music_note,
            title: "Audio Quality",
            subtitle: "High Quality • 320 kbps",
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.download,
            title: "Downloads",
            subtitle: "Manage offline music",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Help & Support",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: "Help Center",
            subtitle: "Get help with your account",
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.feedback,
            title: "Send Feedback",
            subtitle: "Help us improve the app",
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.info_outline,
            title: "About",
            subtitle: "App version 1.0.0",
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            title: "Log Out",
            subtitle: "Sign out from your account",
            textColor: AppColors.accentPink,
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: Icon(icon, color: textColor ?? Colors.white),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: textColor != null
                ? textColor.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.7),
          ),
        ),
        trailing:
            trailing ??
            Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.5)),
        onTap: onTap,
      ),
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: userName),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: AppColors.secondaryText),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryText),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accentGreen),
                ),
              ),
              onChanged: (value) => userName = value,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: TextEditingController(text: userBio),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(color: AppColors.secondaryText),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryText),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accentGreen),
                ),
              ),
              onChanged: (value) => userBio = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGreen,
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Log Out', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: AppColors.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPink,
            ),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
