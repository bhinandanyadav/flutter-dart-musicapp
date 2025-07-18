import 'song_model.dart';
import 'package:flutter/material.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final List<String> artistNames;
  final List<Song> songs;
  final List<String> songIds;
  final String imageUrl;
  final String coverUrl;
  final List<Color> gradientColors;
  final int totalDuration; // in seconds
  final bool isLiked;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    this.artistNames = const [],
    this.songs = const [],
    this.songIds = const [],
    this.imageUrl = '',
    this.coverUrl = '',
    this.gradientColors = const [],
    this.totalDuration = 0,
    this.isLiked = false,
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
