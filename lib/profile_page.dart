import 'package:flutter/material.dart';
import 'app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accentBlue, AppColors.accentPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentPurple.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Abhinandan Yadav",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Premium Subscriber",
                          style: TextStyle(
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // Show edit profile dialog
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Stats section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(context, "Songs", "243"),
                    _buildStatItem(context, "Playlists", "14"),
                    _buildStatItem(context, "Following", "87"),
                    _buildStatItem(context, "Followers", "162"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Account settings
              Text(
                "Account Settings",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 15),
              _buildSettingsItem(
                icon: Icons.person,
                title: "Personal Information",
                subtitle: "Update your personal details",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.credit_card,
                title: "Subscription",
                subtitle: "Manage your premium plan",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.notifications,
                title: "Notifications",
                subtitle: "Configure your alerts",
                onTap: () {},
              ),

              const SizedBox(height: 30),

              // App settings
              Text(
                "App Settings",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 15),
              _buildSettingsItem(
                icon: Icons.download,
                title: "Downloads",
                subtitle: "Manage your offline music",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.music_note,
                title: "Audio Quality",
                subtitle: "Adjust streaming and download quality",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.data_usage,
                title: "Data Saver",
                subtitle: "Reduce data usage while streaming",
                trailing: Switch(
                  value: true,
                  activeColor: AppColors.accentGreen,
                  onChanged: (value) {},
                ),
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.dark_mode,
                title: "Dark Mode",
                subtitle: "Toggle dark theme",
                trailing: Switch(
                  value: true,
                  activeColor: AppColors.accentGreen,
                  onChanged: (value) {},
                ),
                onTap: () {},
              ),

              const SizedBox(height: 30),

              // Support section
              Text(
                "Help & Support",
                style: Theme.of(context).textTheme.displayMedium,
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
                subtitle: "Help us improve your experience",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.logout,
                title: "Log Out",
                subtitle: "Sign out from your account",
                textColor: AppColors.accentPink,
                onTap: () {},
              ),

              const SizedBox(height: 100), // Extra space for mini player
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        ),
      ],
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
        color: AppColors.cardBackground,
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
                // ignore: deprecated_member_use
                ? textColor.withOpacity(0.7)
                // ignore: deprecated_member_use
                : Colors.white.withOpacity(0.7),
          ),
        ),
        trailing:
            trailing ??
            Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5)),
        onTap: onTap,
      ),
    );
  }
}
