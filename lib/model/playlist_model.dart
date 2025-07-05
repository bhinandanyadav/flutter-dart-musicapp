import 'song_model.dart';
import 'package:flutter/material.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final List<String> artistNames;
  final List<Song> songs;
  final String imageUrl;
  final List<Color> gradientColors;
  final int totalDuration; // in seconds

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.artistNames,
    required this.songs,
    required this.imageUrl,
    required this.gradientColors,
    required this.totalDuration,
  });

  String get formattedDuration {
    final int hours = totalDuration ~/ 3600;
    final int minutes = (totalDuration % 3600) ~/ 60;
    final String hoursStr = hours > 0 ? '$hours hr ' : '';
    final String minutesStr = '$minutes min';
    return '$hoursStr$minutesStr';
  }

  String get artistsString {
    return artistNames.join(', ');
  }

  int get songCount => songs.length;
}
