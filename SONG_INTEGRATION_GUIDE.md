# Song Integration Guide

## Overview
This guide explains how to integrate real audio playback into your Flutter music app.

## Current Implementation

### ✅ What's Already Working
- Song model with audio path support
- Real audio playback using `just_audio` package
- Audio service with proper error handling
- Updated music provider with async methods
- Play buttons in library page
- Audio initialization in main app

### 🎵 Audio Files
Currently using: `assets/Dua-Levitating.mp3` for all songs (demo purposes)

## How to Add Your Own Songs

### 1. **Add Audio Files to Assets**
```yaml
# In pubspec.yaml
flutter:
  assets:
    - assets/Dua-Levitating.mp3
    - assets/your-song-1.mp3
    - assets/your-song-2.mp3
    - assets/your-song-3.mp3
```

### 2. **Update Song Data**
In `lib/services/music_service.dart`, update the `_allSongs` list:

```dart
Song(
  id: 'unique-id',
  title: 'Your Song Title',
  artist: 'Artist Name',
  album: 'Album Name',
  duration: '3:45', // Format: MM:SS
  coverUrl: 'path/to/cover.jpg', // Optional
  audioPath: 'assets/your-song.mp3', // Path to audio file
  isLiked: false,
  isDownloaded: true,
),
```

### 3. **Supported Audio Sources**

#### Local Assets (Recommended for demo)
```dart
audioPath: 'assets/song.mp3'
```

#### Network URLs
```dart
audioPath: 'https://example.com/song.mp3'
```

#### Local Files (requires permissions)
```dart
audioPath: '/storage/emulated/0/Music/song.mp3'
```

## Features Available

### ✅ Playback Controls
- Play/Pause
- Seek to position
- Volume control
- Next/Previous song

### ✅ State Management
- Real-time playback state
- Position tracking
- Duration display
- Progress bars

### ✅ UI Integration
- Play buttons on song items
- Like/unlike functionality
- Download indicators
- Song metadata display

## Usage Examples

### Playing a Song
```dart
// In any widget with access to MusicProvider
await musicProvider.playSong(song);
```

### Pausing Playback
```dart
await musicProvider.pausePlayback();
```

### Seeking to Position
```dart
// position is 0.0 to 1.0 (percentage)
await musicProvider.seekTo(0.5); // Seek to 50%
```

### Volume Control
```dart
// volume is 0.0 to 1.0
await musicProvider.setVolume(0.7); // 70% volume
```

## Error Handling

The audio service includes comprehensive error handling:
- Network connectivity issues
- Invalid audio files
- Permission problems
- Playback errors

All errors are logged to console for debugging.

## Next Steps

### 1. **Add More Audio Files**
- Place your MP3 files in the `assets/` folder
- Update `pubspec.yaml` to include them
- Update song data with correct paths

### 2. **Add Album Covers**
- Place cover images in `assets/`
- Update `coverUrl` in song data
- Display covers in UI

### 3. **Implement Playlists**
- Connect songs to playlists
- Add playlist management features
- Implement shuffle/repeat for playlists

### 4. **Add Search Functionality**
- Search by title, artist, album
- Filter by genre, duration, etc.
- Implement fuzzy search

### 5. **Add Download Management**
- Download songs for offline playback
- Manage storage space
- Track download progress

## Troubleshooting

### Common Issues

1. **Audio not playing**
   - Check file path in `audioPath`
   - Ensure file is included in `pubspec.yaml`
   - Verify file format (MP3 recommended)

2. **Permission errors**
   - Add required permissions to Android/iOS configs
   - Request runtime permissions for local files

3. **Network audio issues**
   - Check internet connectivity
   - Verify URL is accessible
   - Handle network timeouts

### Debug Tips

1. Check console logs for error messages
2. Verify audio file paths are correct
3. Test with different audio formats
4. Monitor memory usage with large files

## Performance Considerations

- Use compressed audio formats (MP3, AAC)
- Implement audio caching for network files
- Consider streaming for large files
- Monitor memory usage with many songs

## Platform-Specific Notes

### Android
- Add audio permissions to `AndroidManifest.xml`
- Handle audio focus properly
- Support background playback

### iOS
- Add audio session configuration
- Handle interruptions (calls, etc.)
- Support background audio

### Web
- Browser autoplay policies
- Audio format compatibility
- Network streaming considerations
