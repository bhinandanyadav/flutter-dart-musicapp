# Flutter Dart Music App

A beautiful, modern, and fully-featured music player app built with Flutter and Dart. This app supports real-time music search and playback using multiple music APIs (Spotify, Last.fm, YouTube Music), and is designed for cross-platform use (Android, iOS, Linux, macOS, Windows, Web).

---

## 🎵 Features

- **Modern UI**: Clean, responsive, and visually appealing interface
- **Real-Time Search**: Search for songs, albums, and artists using Spotify, Last.fm, or YouTube Music APIs
- **Audio Playback**: Stream music with real-time controls (play, pause, seek, volume)
- **Mini Player**: Persistent mini player at the bottom of the app
- **Playlists**: Create and manage playlists (demo/mock data, extendable)
- **Trending & Top Tracks**: See trending and top tracks from APIs
- **Like/Favorite Songs**: Mark songs as liked
- **Download Indicator**: Shows which songs are downloaded
- **Cross-Platform**: Works on Android, iOS, Linux, macOS, Windows, and Web
- **Dark Mode**: Beautiful dark theme by default

---

## 🏗️ Architecture

- **Flutter**: UI and cross-platform logic
- **Provider**: State management
- **just_audio**: Audio playback
- **API Services**: Spotify, Last.fm, YouTube Music integration
- **Separation of Concerns**: Models, providers, services, and UI are cleanly separated

---

## 📂 Project Structure

```
lib/
├── app_colors.dart
├── main.dart
├── main_screen.dart
├── my_home_page.dart
├── library_page.dart
├── search_page.dart
├── search_page_api.dart
├── player_page.dart
├── profile_page.dart
├── music_mini.dart
├── model/
│   ├── song_model.dart
│   └── playlist_model.dart
├── providers/
│   └── music_provider.dart
├── services/
│   ├── music_service.dart
│   ├── audio_service.dart
│   ├── spotify_api_service.dart
│   ├── lastfm_api_service.dart
│   └── youtube_music_service.dart
```

---

## 🚀 Getting Started

### 1. **Clone the Repository**
```bash
git clone https://github.com/bhinandanyadav/flutter-dart-musicapp.git
cd flutter-dart-musicapp
```

### 2. **Install Dependencies**
```bash
flutter pub get
```

### 3. **Configure API Keys**
- Copy `API_CONFIG_DEMO.dart` to `api_config.dart` and add your API keys
- Get your keys from:
  - [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
  - [Last.fm API](https://www.last.fm/api/account/create)
- Update the constants in your config file

### 4. **Run the App**
```bash
flutter run
```

---

## 🔑 API Integration

- **Spotify**: 30-second previews, full metadata
- **Last.fm**: Song/artist/album info, recommendations
- **YouTube Music**: Trending and full song URLs (mock/demo)
- **Local Assets**: Demo MP3 included for offline testing

See `API_INTEGRATION_GUIDE.md` and `SONG_INTEGRATION_GUIDE.md` for full details.

---

## 🧩 How It Works

- **Search**: Choose an API and search for any song, artist, or album
- **Play**: Tap the play button to stream audio (from API or local asset)
- **Mini Player**: Controls playback from anywhere in the app
- **Playlists**: View and create playlists (demo, extendable)
- **Trending/Top Tracks**: See what's hot right now

---

## 🛠️ Customization & Extension

- **Add More APIs**: Extend `services/` with new API integrations
- **Add More Features**: Implement playlist management, user authentication, downloads, etc.
- **UI Customization**: Tweak colors, layouts, and animations in `app_colors.dart` and UI files

---

## 📱 Screenshots

> _Add your screenshots here!_

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙏 Credits

- [Flutter](https://flutter.dev/)
- [just_audio](https://pub.dev/packages/just_audio)
- [Spotify Web API](https://developer.spotify.com/documentation/web-api/)
- [Last.fm API](https://www.last.fm/api)
- [YouTube Music](https://music.youtube.com/)

---

**Made with ❤️ by [bhinandanyadav](https://github.com/bhinandanyadav)**
