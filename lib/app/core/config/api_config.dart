import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // API Key dari .env
  static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
  
  // Base URL
  static String get baseUrl => dotenv.env['TMDB_BASE_URL'] ?? '';
  
  // Image Base URL
  static String get imageBaseUrl => dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
  
  // Endpoints
  static const String nowPlayingMovies = '/movie/now_playing';
  static const String popularMovies = '/movie/popular';
  static const String topRatedMovies = '/movie/top_rated';
  static const String upcomingMovies = '/movie/upcoming';
  static const String movieDetail = '/movie';
  static const String searchMovies = '/search/movie';
  static const String movieCredits = '/movie/{movie_id}/credits';
  static const String similarMovies = '/movie/{movie_id}/similar';
  
  // Helper untuk build image URL
  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl$path';
  }
  
  // Helper untuk build full URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}