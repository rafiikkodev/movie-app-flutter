import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:template_project_flutter/app/core/config/api_config.dart';

class TmdbService {
  // GET Request Helper
  Future<Map<String, dynamic>> _get(String endpoint, {Map<String, dynamic>? params}) async {
    final queryParams = {
      'api_key': ApiConfig.apiKey,
      'language': 'en-US',
      ...?params,
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // FETCH POPULAR MOVIES
  Future<Map<String, dynamic>> getPopularMovies({int page = 1}) async {
    return await _get('/movie/popular', params: {'page': page.toString()});
  }

  // FETCH NOW PLAYING
  Future<Map<String, dynamic>> getNowPlayingMovies({int page = 1}) async {
    return await _get('/movie/now_playing', params: {'page': page.toString()});
  }

  // FETCH TOP RATED
  Future<Map<String, dynamic>> getTopRatedMovies({int page = 1}) async {
    return await _get('/movie/top_rated', params: {'page': page.toString()});
  }

  // FETCH UPCOMING
  Future<Map<String, dynamic>> getUpcomingMovies({int page = 1}) async {
    return await _get('/movie/upcoming', params: {'page': page.toString()});
  }

  // FETCH MOVIE DETAIL
  Future<Map<String, dynamic>> getMovieDetail(int movieId) async {
    return await _get('/movie/$movieId');
  }

  // FETCH MOVIE CREDITS (Cast & Crew)
  Future<Map<String, dynamic>> getMovieCredits(int movieId) async {
    return await _get('/movie/$movieId/credits');
  }

  // FETCH MOVIE VIDEOS (Trailers)
  Future<Map<String, dynamic>> getMovieVideos(int movieId) async {
    return await _get('/movie/$movieId/videos');
  }

  // SEARCH MOVIES
  Future<Map<String, dynamic>> searchMovies(String query, {int page = 1}) async {
    return await _get('/search/movie', params: {
      'query': query,
      'page': page.toString(),
    });
  }

  // FETCH SIMILAR MOVIES
  Future<Map<String, dynamic>> getSimilarMovies(int movieId, {int page = 1}) async {
    return await _get('/movie/$movieId/similar', params: {'page': page.toString()});
  }
}