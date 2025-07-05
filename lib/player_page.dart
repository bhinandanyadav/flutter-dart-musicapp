import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'app_colors.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _sliderValue = 0.7;
  bool _isPlaying = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
          icon: const Icon(Icons.keyboard_arrow_down),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "NOW PLAYING",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Circular album art with visualizer
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle (visualizer)
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: VisualizerPainter(
                                animation: _animationController.value,
                                isPlaying: _isPlaying,
                              ),
                              child: child,
                            );
                          },
                        ),
                      ),

                      // Inner circle (album art)
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.accentPurple,
                              AppColors.accentBlue,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentPurple.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _isPlaying
                                  ? _animationController.value * 2 * math.pi
                                  : 0,
                              child: child,
                            );
                          },
                          child: const Center(
                            child: Icon(
                              Icons.music_note,
                              size: 80,
                              color: Colors.white24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Song info
                Column(
                  children: [
                    const Text(
                      "Blinding Lights",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "The Weeknd",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Progress slider
                Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.accentGreen,
                        inactiveTrackColor: Colors.white.withOpacity(0.2),
                        thumbColor: AppColors.accentGreen,
                        trackHeight: 4.0,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6.0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14.0,
                        ),
                      ),
                      child: Slider(
                        value: _sliderValue,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Time indicators
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "2:15",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "3:20",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Shuffle button
                    IconButton(
                      icon: const Icon(Icons.shuffle),
                      color: Colors.white.withOpacity(0.7),
                      iconSize: 25,
                      onPressed: () {},
                    ),

                    // Previous button
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      color: Colors.white,
                      iconSize: 40,
                      onPressed: () {},
                    ),

                    // Play/Pause button
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _isPlaying
                              ? AppColors.greenGradient
                              : [Colors.white, Colors.white70],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isPlaying
                                ? AppColors.accentGreen.withOpacity(0.3)
                                : Colors.white.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: _isPlaying
                              ? Colors.white
                              : AppColors.background,
                        ),
                        iconSize: 35,
                        onPressed: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                            if (_isPlaying) {
                              _animationController.repeat();
                            } else {
                              _animationController.stop();
                            }
                          });
                        },
                      ),
                    ),

                    // Next button
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      color: Colors.white,
                      iconSize: 40,
                      onPressed: () {},
                    ),

                    // Favorite button
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite
                            ? AppColors.accentPink
                            : Colors.white.withOpacity(0.7),
                      ),
                      iconSize: 25,
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Bottom options row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Playlist button
                    _buildCircleButton(
                      Icons.playlist_play,
                      Colors.white.withOpacity(0.05),
                      () {},
                    ),

                    const SizedBox(width: 20),

                    // Download button
                    _buildCircleButton(
                      Icons.file_download_outlined,
                      Colors.white.withOpacity(0.05),
                      () {},
                    ),

                    const SizedBox(width: 20),

                    // Share button
                    _buildCircleButton(
                      Icons.share_outlined,
                      Colors.white.withOpacity(0.05),
                      () {},
                    ),
                  ],
                ),

                const SizedBox(height: 40), // Extra bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// Custom painter for music visualizer effect
class VisualizerPainter extends CustomPainter {
  final double animation;
  final bool isPlaying;

  VisualizerPainter({required this.animation, required this.isPlaying});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Define paint for circle
    final circlePaint = Paint()
      ..color = AppColors.cardBackground.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Draw background circle
    canvas.drawCircle(center, radius, circlePaint);

    if (!isPlaying) return;

    // Draw visualizer bars
    final barCount = 60;
    final angleStep = 2 * math.pi / barCount;
    final barWidth = 3.0;

    for (int i = 0; i < barCount; i++) {
      final angle = angleStep * i;
      // Generate a pseudo-random height based on animation and angle
      final seed = (animation * 10 + i / 10) % 1.0;
      final barHeight = (0.3 + 0.7 * _getNoise(seed)) * 30;

      // Calculate bar positions
      final startRadiusOuter = radius + 5;
      final endRadiusOuter = startRadiusOuter + barHeight;

      final startPoint = Offset(
        center.dx + startRadiusOuter * math.cos(angle),
        center.dy + startRadiusOuter * math.sin(angle),
      );

      final endPoint = Offset(
        center.dx + endRadiusOuter * math.cos(angle),
        center.dy + endRadiusOuter * math.sin(angle),
      );

      // Define gradient based on position
      final paint = Paint()
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;

      // Alternate colors for visualizer bars
      if (i % 3 == 0) {
        paint.color = AppColors.accentGreen;
      } else if (i % 3 == 1) {
        paint.color = AppColors.accentBlue;
      } else {
        paint.color = AppColors.accentPurple;
      }

      // Draw the bar
      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  // Simple noise function for pseudo-randomness
  double _getNoise(double value) {
    return math.sin(value * 12.9898 + 78.233) * 0.5 + 0.5;
  }

  @override
  bool shouldRepaint(covariant VisualizerPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.isPlaying != isPlaying;
  }
}
