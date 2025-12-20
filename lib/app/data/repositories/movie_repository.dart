// mengelola data dari provider (gabung, proses, chaching) | sebagai jembatan antara provider(API) dan UI

import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/data/providers/movie_provider.dart';

class MovieRepository {
  final MovieProvider _provider = MovieProvider();

  // Get Now Playing Movies
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _provider.getNowPlayingMovies(page: page);
      return response.results;
    } catch (e) {
      rethrow;
    }
  }

  // Get Popular Movies
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _provider.getPopularMovies(page: page);
      return response.results;
    } catch (e) {
      rethrow;
    }
  }

  // Get Top Rated Movies
  Future<List<MovieModel>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _provider.getTopRatedMovies(page: page);
      return response.results;
    } catch (e) {
      rethrow;
    }
  }

  // Get Upcoming Movies
  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _provider.getUpcomingMovies(page: page);
      return response.results;
    } catch (e) {
      rethrow;
    }
  }

  // Search Movies
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _provider.searchMovies(query, page: page);
      return response.results;
    } catch (e) {
      rethrow;
    }
  }

  // Get Movie Detail
  Future<MovieModel> getMovieDetail(int movieId) async {
    try {
      return await _provider.getMovieDetail(movieId);
    } catch (e) {
      rethrow;
    }
  }

  // Alias for getMovieDetail (for consistency)
  Future<MovieModel> getMovieById(int movieId) async {
    return getMovieDetail(movieId);
  }

  // Get Similar Movies
  Future<List<MovieModel>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      final response = await _provider.getSimilarMovies(movieId, page: page);
      return response.results;
    } catch (e) {
      rethrow;
    }
  }
}
