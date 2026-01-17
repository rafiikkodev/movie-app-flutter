import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/core/utils/logger.dart';

class FavoriteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Singleton pattern
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  // Get current user ID
  String? get _userId => _supabase.auth.currentUser?.id;

  // INSERT FAVORITE
  Future<bool> addFavorite(MovieModel movie) async {
    try {
      if (_userId == null) throw Exception('User not logged in');

      await _supabase.from('favorites').insert({
        'user_id': _userId,
        'movie_id': movie.id,
        'title': movie.title,
        'poster_path': movie.posterPath,
        'vote_average': movie.voteAverage,
        'release_date': movie.releaseDate,
        'genre_names': movie.genreNamesDisplay,
      });

      LoggerService.success('Added to favorites', movie.title);
      return true;
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        LoggerService.info('Movie already in favorites');
        return false;
      }
      LoggerService.error('Error adding favorite', e);
      rethrow;
    } catch (e) {
      LoggerService.error('Error adding favorite', e);
      rethrow;
    }
  }

  // GET FAVORITES
  Future<List<MovieModel>> getFavorites() async {
    try {
      if (_userId == null) return [];

      final response = await _supabase
          .from('favorites')
          .select(
            'movie_id, title, poster_path, vote_average, release_date, genre_names',
          )
          .eq('user_id', _userId!)
          .order('created_at', ascending: false)
          .limit(100);

      return (response as List)
          .map(
            (json) => MovieModel(
              id: json['movie_id'],
              title: json['title'],
              overview: '',
              posterPath: json['poster_path'],
              voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
              releaseDate: json['release_date'] ?? '',
              genreIds: [],
              genreNames: json['genre_names'] ?? '',
            ),
          )
          .toList();
    } catch (e) {
      LoggerService.error('Error getting favorites', e);
      return [];
    }
  }

  // DELETE FAVORITE
  Future<bool> removeFavorite(int movieId) async {
    try {
      if (_userId == null) throw Exception('User not logged in');

      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', _userId!)
          .eq('movie_id', movieId);

      LoggerService.success('Removed from favorites', movieId);
      return true;
    } catch (e) {
      LoggerService.error('Error removing favorite', e);
      rethrow;
    }
  }

  // CHECK IF FAVORITE
  Future<bool> isFavorite(int movieId) async {
    try {
      if (_userId == null) return false;

      final response = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', _userId!)
          .eq('movie_id', movieId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      LoggerService.error('Error checking favorite', e);
      return false;
    }
  }

  // TOGGLE FAVORITE
  Future<bool> toggleFavorite(MovieModel movie) async {
    final isCurrentlyFavorite = await isFavorite(movie.id);

    if (isCurrentlyFavorite) {
      await removeFavorite(movie.id);
      return false;
    } else {
      await addFavorite(movie);
      return true;
    }
  }

  // GET FAVORITE COUNT
  Future<int> getFavoriteCount() async {
    try {
      if (_userId == null) return 0;

      final response = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', _userId!);

      return (response as List).length;
    } catch (e) {
      LoggerService.error('Error getting favorite count', e);
      return 0;
    }
  }

  // CLEAR ALL FAVORITES
  Future<void> clearAllFavorites() async {
    try {
      if (_userId == null) throw Exception('User not logged in');

      await _supabase.from('favorites').delete().eq('user_id', _userId!);

      LoggerService.info('All favorites cleared');
    } catch (e) {
      LoggerService.error('Error clearing favorites', e);
      rethrow;
    }
  }
}
