// melakukan req ke API TMDB (data source)

import 'package:dio/dio.dart';
import 'package:template_project_flutter/app/core/config/api_config.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';

class MovieProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Get Now Playing Movies
  Future<MovieListResponse> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConfig.nowPlayingMovies,
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'en-US',
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load now playing movies');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Get Popular Movies
  Future<MovieListResponse> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConfig.popularMovies,
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'en-US',
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load popular movies');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Get Top Rated Movies
  Future<MovieListResponse> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConfig.topRatedMovies,
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'en-US',
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load top rated movies');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Search Movies
  Future<MovieListResponse> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConfig.searchMovies,
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'en-US',
          'query': query,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to search movies');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Get Movie Detail
  Future<MovieModel> getMovieDetail(int movieId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.movieDetail}/$movieId',
        queryParameters: {'api_key': ApiConfig.apiKey, 'language': 'en-US'},
      );

      if (response.statusCode == 200) {
        return MovieModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load movie detail');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  // Get Similar Movies
  Future<MovieListResponse> getSimilarMovies(
    int movieId, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId/similar',
        queryParameters: {
          'api_key': ApiConfig.apiKey,
          'language': 'en-US',
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        return MovieListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load similar movies');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
