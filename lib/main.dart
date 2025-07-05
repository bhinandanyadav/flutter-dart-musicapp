import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'main_screen.dart';
import 'services/music_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize music service
  final musicService = MusicService();
  await musicService.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: AppColors.primaryText, fontSize: 16),
          bodyMedium: TextStyle(color: AppColors.secondaryText, fontSize: 14),
        ),
        colorScheme: ColorScheme.dark(
          primary: AppColors.accentGreen,
          secondary: AppColors.accentPurple,
          surface: AppColors.cardBackground,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
