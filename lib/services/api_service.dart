import 'package:dio/dio.dart';
import 'package:rapiddown_challenge/env/env.dart';

class PexelsApiService {
  // Base URLs for photos and videos endpoints
  static final String _photoBaseUrl = 'https://api.pexels.com/v1/';
  static final String _videoBaseUrl = 'https://api.pexels.com/videos/';

  final Dio _dio;

  /// Constructor that initializes Dio with the API key from dotenv.
  PexelsApiService()
    : _dio = Dio(
        BaseOptions(
          headers: {'Authorization': EnvironmentVariables.pexelsApiKey},
        ),
      );

  /// Fetches curated photos.
  /// [perPage] sets the number of photos per page.
  Future<List<dynamic>> fetchPhotos(int perPage) async {
    try {
      final response = await _dio.get(
        '$_photoBaseUrl'
        'curated?per_page=$perPage',
      );
      return response.data['photos'];
    } catch (e) {
      throw Exception('Failed to load photos: $e');
    }
  }

  /// Searches photos with the given [query].
  /// [perPage] sets the number of photos per page.
  Future<List<dynamic>> searchPhotos(String query, int perPage) async {
    try {
      final response = await _dio.get(
        '$_photoBaseUrl'
        'search?query=$query&per_page=$perPage',
      );
      return response.data['photos'];
    } catch (e) {
      throw Exception('Failed to search photos: $e');
    }
  }

  /// Fetches detailed information for a photo by its [id].
  Future<Map<String, dynamic>> fetchPhotoById(int id) async {
    try {
      final response = await _dio.get(
        '$_photoBaseUrl'
        'photos/$id',
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch photo details: $e');
    }
  }

  /// Fetches popular videos.
  /// [perPage] sets the number of videos per page.
  Future<List<dynamic>> fetchPopularVideos(int perPage) async {
    try {
      final response = await _dio.get(
        '$_videoBaseUrl'
        'popular?per_page=$perPage',
      );
      return response.data['videos'];
    } catch (e) {
      throw Exception('Failed to load popular videos: $e');
    }
  }

  /// Searches videos with the given [query].
  /// [perPage] sets the number of videos per page.
  Future<List<dynamic>> searchVideos(String query, int perPage) async {
    try {
      final response = await _dio.get(
        '$_videoBaseUrl'
        'search?query=$query&per_page=$perPage',
      );
      return response.data['videos'];
    } catch (e) {
      throw Exception('Failed to search videos: $e');
    }
  }
}
