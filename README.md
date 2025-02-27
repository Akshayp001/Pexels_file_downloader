# Flutter File Downloader App

A feature-rich file downloader application built with Flutter that integrates with RapidAPI to fetch and download various media files to your device.

![App Banner](https://via.placeholder.com/800x200)

## 📱 App Features

- **API Integration**: Seamlessly fetches downloadable content from Pexels API via RapidAPI
- **Elegant UI/UX**: Polished interface with smooth animations and transitions
- **Multiple View Options**: Toggle between grid view (4×2) and list view
- **Advanced Download Management**: Download progress tracking with completion notifications
- **File Preview**: Open and view downloaded files directly within the app
- **Powerful Search**: Quickly find content by name or type
- **Dedicated Downloads Tab**: Access all your downloaded files in one place
- **Splash Screen**: Engaging app entry experience with custom animations

## 📸 Screenshots

<div style="display: flex; flex-wrap: wrap; justify-content: space-between;">
  <img src="/screenshots/splash_screen.png" width="200" alt="Splash Screen">
  <img src="/screenshots/home_grid_view.png" width="200" alt="Home Grid View">
  <img src="/screenshots/home_list_view.png" width="200" alt="Home List View">
  <img src="/screenshots/downloading_progress.png" width="200" alt="Downloading Progress">
  <img src="/screenshots/file_preview.png" width="200" alt="File Preview">
</div>



## 🛠️ Tech Stack

- **Flutter & Dart**: Core framework and language
- **Provider**: State management solution for reactive and efficient UI updates
- **Dio**: HTTP client for API requests and file downloads
- **path_provider**: Managing file system locations
- **open_file**: Handling file opening operations
- **flutter_staggered_animations**: Creating beautiful animations for list/grid items
- **animated_splash_screen**: Custom splash screen implementation
- **shared_preferences**: Persistent storage for app settings

## 📚 API Used

This app integrates with the [Pexels API](https://api.pexels.com/v1/) via Pexels to fetch high-quality images, videos, and other media files. The API provides:

- High-resolution stock photos and videos
- Extensive search capabilities
- Detailed file metadata
- Free tier with generous request limits

## 🏗️ Architecture & State Management

The app follows a clean architecture approach with:

- **Repository Pattern**: Abstracts data sources and provides a clean API for the UI
- **Service Layer**: Handles API communication and file download operations
- **Provider State Management**: Manages UI state and provides reactive updates
- **Model-View-ViewModel (MVVM)**: Separates business logic from UI components

The Provider package was chosen for state management due to its:
- Simplicity and ease of implementation
- Efficient rebuilding of only the affected UI components
- Good integration with Flutter's widget lifecycle
- Scalability for the app's feature set

## ⚙️ Implementation Details

### Download Service

The app implements a robust download service that:
- Handles concurrent downloads efficiently
- Provides real-time progress updates
- Manages file storage appropriately
- Implements proper error handling and retry mechanisms
- Validates downloaded files to ensure integrity

### File Management

Downloaded files are:
- Stored in the application's documents directory
- Categorized by file type
- Easily accessible through the Downloads tab
- Managed with appropriate permissions for Android and iOS

### UI Animations

The app features several custom animations:
- Staggered animations for list/grid items loading
- Progress indicators during downloads
- Transition animations between screens
- Micro-interactions for buttons and user actions

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (version 2.17.0 or higher)
- RapidAPI account with access to Pexels API
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/flutter_file_downloader.git
   ```

2. Navigate to project directory:
   ```bash
   cd flutter_file_downloader
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Create a `env.dart` file in `lib/env/` directory as per env.dart.example :
   ```dart
   class EnvironmentVariables {
   static const String pexelsApiKey =
         'T*****WGd************************';
   }
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## 📝 Future Improvements

- Implement background downloads
- Add support for more file types and sources
- Create a more advanced file management system
- Add user authentication to sync downloads across devices
- Implement download scheduling
- Add offline mode capabilities

## 🤝 Contribution

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
