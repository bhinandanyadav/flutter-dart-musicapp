import 'package:flutter/material.dart';
import '../model/song_model.dart';
import '../services/enhanced_music_service.dart';
import '../app_colors.dart';

class FuturisticPlayerPage extends StatefulWidget {
  const FuturisticPlayerPage({super.key});

  @override
  State<FuturisticPlayerPage> createState() => _FuturisticPlayerPageState();
}

class _FuturisticPlayerPageState extends State<FuturisticPlayerPage>
    with TickerProviderStateMixin {
  final EnhancedMusicService _musicService = EnhancedMusicService();
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _showLyrics = false;
  bool _showEqualizer = false;
  double _currentSliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);

    _musicService.playingStream.listen((isPlaying) {
      if (isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primaryText,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Now Playing',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primaryText),
            onPressed: () => _showOptionsBottomSheet(context),
          ),
        ],
      ),
      body: StreamBuilder<Song?>(
        stream: Stream.periodic(
          const Duration(milliseconds: 100),
          (_) => _musicService.currentSong,
        ),
        builder: (context, snapshot) {
          final song = snapshot.data;
          if (song == null) {
            return const Center(
              child: Text(
                'No song selected',
                style: TextStyle(color: AppColors.primaryText, fontSize: 18),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildAlbumArt(song),
                      const SizedBox(height: 30),
                      _buildSongInfo(song),
                      const SizedBox(height: 30),
                      _buildProgressBar(),
                      const SizedBox(height: 30),
                      _buildControlButtons(),
                      const SizedBox(height: 20),
                      _buildVolumeControl(),
                      const SizedBox(height: 20),
                      _buildAdditionalControls(),
                      if (_showLyrics) _buildLyrics(),
                      if (_showEqualizer) _buildEqualizer(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAlbumArt(Song song) {
    return Container(
      height: 280,
      width: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationController.value * 2 * 3.14159,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accent.withValues(alpha: 0.8),
                          AppColors.accent.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    child: ClipOval(
                      child: song.coverUrl.isNotEmpty
                          ? Image.network(
                              song.coverUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultAlbumArt();
                              },
                            )
                          : _buildDefaultAlbumArt(),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultAlbumArt() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
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
        size: 100,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildSongInfo(Song song) {
    return Column(
      children: [
        Text(
          song.title,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          song.artist,
          style: const TextStyle(color: AppColors.secondaryText, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          song.album,
          style: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        if (song.genre != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              song.genre!,
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressBar() {
    return StreamBuilder<Duration?>(
      stream: _musicService.positionStream,
      builder: (context, positionSnapshot) {
        return StreamBuilder<Duration?>(
          stream: _musicService.durationStream,
          builder: (context, durationSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            final duration = durationSnapshot.data ?? Duration.zero;
            final progress = duration.inMilliseconds > 0
                ? position.inMilliseconds / duration.inMilliseconds
                : 0.0;

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                      activeTrackColor: AppColors.accent,
                      inactiveTrackColor: AppColors.secondaryText.withValues(alpha: 
                        0.3,
                      ),
                      thumbColor: AppColors.accent,
                      overlayColor: AppColors.accent.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: progress.clamp(0.0, 1.0),
                      onChanged: (value) {
                        final newPosition = Duration(
                          milliseconds: (value * duration.inMilliseconds)
                              .round(),
                        );
                        _musicService.seekTo(newPosition);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: _musicService.isShuffleOn ? Icons.shuffle : Icons.shuffle,
          isActive: _musicService.isShuffleOn,
          onPressed: () {
            setState(() {
              _musicService.toggleShuffle();
            });
          },
        ),
        _buildControlButton(
          icon: Icons.skip_previous,
          size: 35,
          onPressed: () => _musicService.skipToPrevious(),
        ),
        StreamBuilder<bool>(
          stream: _musicService.playingStream,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data ?? false;
            return Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0.8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.primaryText,
                  size: 35,
                ),
                onPressed: () => _musicService.playPause(),
              ),
            );
          },
        ),
        _buildControlButton(
          icon: Icons.skip_next,
          size: 35,
          onPressed: () => _musicService.skipToNext(),
        ),
        _buildControlButton(
          icon: _musicService.isRepeatOn ? Icons.repeat_one : Icons.repeat,
          isActive: _musicService.isRepeatOn,
          onPressed: () {
            setState(() {
              _musicService.toggleRepeat();
            });
          },
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    bool isActive = false,
    double size = 25,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppColors.accent.withValues(alpha: 0.2)
            : Colors.transparent,
        border: isActive ? Border.all(color: AppColors.accent, width: 1) : null,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isActive ? AppColors.accent : AppColors.secondaryText,
          size: size,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          const Icon(
            Icons.volume_down,
            color: AppColors.secondaryText,
            size: 20,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: AppColors.accent,
                inactiveTrackColor: AppColors.secondaryText.withValues(alpha: 0.3),
                thumbColor: AppColors.accent,
                overlayColor: AppColors.accent.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: _musicService.volume,
                onChanged: (value) => _musicService.setVolume(value),
              ),
            ),
          ),
          const Icon(Icons.volume_up, color: AppColors.secondaryText, size: 20),
        ],
      ),
    );
  }

  Widget _buildAdditionalControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            _showLyrics ? Icons.lyrics : Icons.lyrics_outlined,
            color: _showLyrics ? AppColors.accent : AppColors.secondaryText,
          ),
          onPressed: () => setState(() => _showLyrics = !_showLyrics),
        ),
        IconButton(
          icon: Icon(
            _showEqualizer ? Icons.equalizer : Icons.equalizer_outlined,
            color: _showEqualizer ? AppColors.accent : AppColors.secondaryText,
          ),
          onPressed: () => setState(() => _showEqualizer = !_showEqualizer),
        ),
        IconButton(
          icon: const Icon(Icons.speed, color: AppColors.secondaryText),
          onPressed: () => _showSpeedDialog(),
        ),
        IconButton(
          icon: const Icon(Icons.timer, color: AppColors.secondaryText),
          onPressed: () => _showSleepTimerDialog(),
        ),
      ],
    );
  }

  Widget _buildLyrics() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lyrics',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Lyrics will be displayed here...\n\nThis is a placeholder for lyrics functionality.\nIntegration with lyrics APIs can be added here.',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEqualizer() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Equalizer',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEQSlider('60Hz', 0.5),
              _buildEQSlider('170Hz', 0.3),
              _buildEQSlider('310Hz', 0.7),
              _buildEQSlider('600Hz', 0.4),
              _buildEQSlider('1kHz', 0.6),
              _buildEQSlider('3kHz', 0.5),
              _buildEQSlider('6kHz', 0.8),
              _buildEQSlider('12kHz', 0.4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEQSlider(String label, double value) {
    return Column(
      children: [
        Container(
          height: 100,
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                activeTrackColor: AppColors.accent,
                inactiveTrackColor: AppColors.secondaryText.withValues(alpha: 0.3),
                thumbColor: AppColors.accent,
              ),
              child: Slider(
                value: value,
                onChanged: (newValue) {
                  // Handle EQ changes
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.secondaryText, fontSize: 10),
        ),
      ],
    );
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Playback Speed',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSpeedOption('0.5x', 0.5),
            _buildSpeedOption('0.75x', 0.75),
            _buildSpeedOption('1.0x', 1.0),
            _buildSpeedOption('1.25x', 1.25),
            _buildSpeedOption('1.5x', 1.5),
            _buildSpeedOption('2.0x', 2.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedOption(String label, double speed) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: AppColors.primaryText)),
      trailing: _musicService.playbackSpeed == speed
          ? const Icon(Icons.check, color: AppColors.accent)
          : null,
      onTap: () {
        _musicService.setPlaybackSpeed(speed);
        Navigator.pop(context);
      },
    );
  }

  void _showSleepTimerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Sleep Timer',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimerOption('15 minutes', const Duration(minutes: 15)),
            _buildTimerOption('30 minutes', const Duration(minutes: 30)),
            _buildTimerOption('45 minutes', const Duration(minutes: 45)),
            _buildTimerOption('1 hour', const Duration(hours: 1)),
            _buildTimerOption('2 hours', const Duration(hours: 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerOption(String label, Duration duration) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: AppColors.primaryText)),
      onTap: () {
        _musicService.audioService.setSleepTimer(duration);
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sleep timer set for $label')));
      },
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOptionItem(Icons.queue_music, 'Add to Queue', () {}),
            _buildOptionItem(Icons.playlist_add, 'Add to Playlist', () {}),
            _buildOptionItem(Icons.share, 'Share', () {}),
            _buildOptionItem(Icons.info_outline, 'Song Info', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryText),
      title: Text(title, style: const TextStyle(color: AppColors.primaryText)),
      onTap: onTap,
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
