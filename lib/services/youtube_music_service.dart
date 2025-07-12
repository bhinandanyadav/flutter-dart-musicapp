import '../model/song_model.dart';

class YouTubeMusicService {
  // Search for songs on YouTube Music
  Future<List<Song>> searchSongs(String query, {int limit = 20}) async {
    try {
      // This is a simplified approach - in a real app, you'd use yt-dlp or similar
      // For now, we'll return mock data with YouTube URLs

      final mockSongs = [
        Song(
          id: 'yt_1',
          title: 'Blinding Lights',
          artist: 'The Weeknd',
          album: 'After Hours',
          duration: '3:20',
          coverUrl: 'https://i.ytimg.com/vi/4NRXx6U8ABQ/maxresdefault.jpg',
          audioPath: 'https://www.youtube.com/watch?v=4NRXx6U8ABQ',
          isLiked: false,
          isDownloaded: false,
        ),
        Song(
          id: 'yt_2',
          title: 'Levitating',
          artist: 'Dua Lipa',
          album: 'Future Nostalgia',
          duration: '3:23',
          coverUrl: 'https://i.ytimg.com/vi/TUVcZfQe-Kw/maxresdefault.jpg',
          audioPath: 'https://www.youtube.com/watch?v=TUVcZfQe-Kw',
          isLiked: false,
          isDownloaded: false,
        ),
        Song(
          id: 'yt_3',
          title: 'Stay',
          artist: 'The Kid LAROI, Justin Bieber',
          album: 'F*CK LOVE 3: OVER YOU',
          duration: '2:21',
          coverUrl: 'https://i.ytimg.com/vi/kTJczUoc26U/maxresdefault.jpg',
          audioPath: 'https://www.youtube.com/watch?v=kTJczUoc26U',
          isLiked: false,
          isDownloaded: false,
        ),
      ];

      // Filter based on query
      return mockSongs
          .where(
            (song) =>
                song.title.toLowerCase().contains(query.toLowerCase()) ||
                song.artist.toLowerCase().contains(query.toLowerCase()),
          )
          .take(limit)
          .toList();
    } catch (e) {
      print('Error searching YouTube Music: $e');
      return [];
    }
  }

  // Get trending songs
  Future<List<Song>> getTrendingSongs({int limit = 20}) async {
    try {
      // Mock trending songs
      return [
        Song(
          id: 'yt_trending_1',
          title: 'As It Was',
          artist: 'Harry Styles',
          album: 'Harry\'s House',
          duration: '2:47',
          coverUrl: 'https://i.ytimg.com/vi/H5v3kku4y6Q/maxresdefault.jpg',
          audioPath: 'https://www.youtube.com/watch?v=H5v3kku4y6Q',
          isLiked: false,
          isDownloaded: false,
        ),
        Song(
          id: 'yt_trending_2',
          title: 'About Damn Time',
          artist: 'Lizzo',
          album: 'Special',
          duration: '3:11',
          coverUrl: 'https://i.ytimg.com/vi/0VH9WCFV6XQ/maxresdefault.jpg',
          audioPath: 'https://www.youtube.com/watch?v=0VH9WCFV6XQ',
          isLiked: false,
          isDownloaded: false,
        ),
        Song(
          id: 'yt_trending_3',
          title: 'Late Night Talking',
          artist: 'Harry Styles',
          album: 'Harry\'s House',
          duration: '2:57',
          coverUrl: 'https://i.ytimg.com/vi/0VH9WCFV6XQ/maxresdefault.jpg',
          audioPath: 'https://www.youtube.com/watch?v=0VH9WCFV6XQ',
          isLiked: false,
          isDownloaded: false,
        ),
      ];
    } catch (e) {
      print('Error getting trending songs: $e');
      return [];
    }
  }

  // Get audio stream URL (this would require yt-dlp integration)
  Future<String?> getAudioStreamUrl(String videoId) async {
    try {
      // In a real implementation, you would use yt-dlp to extract audio URLs
      // For now, we'll return a placeholder
      return 'https://www.youtube.com/watch?v=$videoId';
    } catch (e) {
      print('Error getting audio stream URL: $e');
      return null;
    }
  }

  // Extract video ID from YouTube URL
  String? extractVideoId(String url) {
    final regExp = RegExp(
      r'(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([^&\n?#]+)',
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }
}
