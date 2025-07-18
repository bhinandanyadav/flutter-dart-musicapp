import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'app_colors.dart';

class SimpleMusicApp extends StatefulWidget {
  const SimpleMusicApp({super.key});

  @override
  State<SimpleMusicApp> createState() => _SimpleMusicAppState();
}

class _SimpleMusicAppState extends State<SimpleMusicApp> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  final String _currentSong = 'Dua Lipa - Levitating';
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('Dua-Levitating.mp3'));
    }
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
  }

  Future<void> _seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> _setVolume(double volume) async {
    _volume = volume;
    await _audioPlayer.setVolume(_volume);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Enhanced Music Player',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Album Art
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      // ignore: deprecated_member_use
                      AppColors.accent.withValues(alpha: 0.8),
                      // ignore: deprecated_member_use
                      AppColors.accent.withValues(alpha: 0.3),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.music_note,
                    size: 80,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),
          ),

          // Song Info
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  _currentSong,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enhanced Music App',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Progress Bar
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
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
                      // ignore: deprecated_member_use
                      inactiveTrackColor: AppColors.secondaryText.withValues(alpha: 
                        0.3,
                      ),
                      thumbColor: AppColors.accent,
                      // ignore: deprecated_member_use
                      overlayColor: AppColors.accent.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: _totalDuration.inMilliseconds > 0
                          ? _currentPosition.inMilliseconds /
                                _totalDuration.inMilliseconds
                          : 0.0,
                      onChanged: (value) {
                        final position = Duration(
                          milliseconds: (value * _totalDuration.inMilliseconds)
                              .round(),
                        );
                        _seek(position);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_currentPosition),
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatDuration(_totalDuration),
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
          ),

          // Control Buttons
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardBackground,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                      color: AppColors.primaryText,
                      size: 25,
                    ),
                    onPressed: () => _stop(),
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.accent,
                        // ignore: deprecated_member_use
                        AppColors.accent.withValues(alpha: 0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.primaryText,
                      size: 35,
                    ),
                    onPressed: _playPause,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardBackground,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                      color: AppColors.primaryText,
                      size: 25,
                    ),
                    onPressed: () => _stop(),
                  ),
                ),
              ],
            ),
          ),

          // Volume Control
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
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
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                        activeTrackColor: AppColors.accent,
                        // ignore: deprecated_member_use
                        inactiveTrackColor: AppColors.secondaryText.withValues(alpha: 
                          0.3,
                        ),
                        thumbColor: AppColors.accent,
                        // ignore: deprecated_member_use
                        overlayColor: AppColors.accent.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: _volume,
                        onChanged: (value) {
                          setState(() {
                            _volume = value;
                          });
                          _setVolume(value);
                        },
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.volume_up,
                    color: AppColors.secondaryText,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Status
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isPlaying ? '🎵 Playing' : '⏸️ Paused',
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
