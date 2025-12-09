import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';

class FavoriteService {
  static const String _favoritesKey = 'favorite_movies';

  // Singleton pattern
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  // Get all favorite movies
  Future<List<MovieModel>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson == null || favoritesJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = json.decode(favoritesJson);
      return decoded.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  // Add movie to favorites
  Future<bool> addFavorite(MovieModel movie) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      // Check if already exists
      if (favorites.any((m) => m.id == movie.id)) {
        return false;
      }

      favorites.add(movie);
      final String encoded = json.encode(
        favorites.map((m) => m.toJson()).toList(),
      );

      return await prefs.setString(_favoritesKey, encoded);
    } catch (e) {
      print('Error adding favorite: $e');
      return false;
    }
  }

  // Remove movie from favorites
  Future<bool> removeFavorite(int movieId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      favorites.removeWhere((m) => m.id == movieId);

      final String encoded = json.encode(
        favorites.map((m) => m.toJson()).toList(),
      );

      return await prefs.setString(_favoritesKey, encoded);
    } catch (e) {
      print('Error removing favorite: $e');
      return false;
    }
  }

  // Check if movie is favorite
  Future<bool> isFavorite(int movieId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((m) => m.id == movieId);
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(MovieModel movie) async {
    final isCurrentlyFavorite = await isFavorite(movie.id);

    if (isCurrentlyFavorite) {
      return await removeFavorite(movie.id);
    } else {
      return await addFavorite(movie);
    }
  }

  // Clear all favorites
  Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_favoritesKey);
    } catch (e) {
      print('Error clearing favorites: $e');
      return false;
    }
  }

  // Get favorite count
  Future<int> getFavoriteCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }
}
