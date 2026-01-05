import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';

/// FavoriteProvider dengan optimistic update untuk UI yang responsif
///
/// Fitur:
/// - **Optimistic Update**: UI langsung terupdate tanpa menunggu server
/// - **Shared State**: Semua halaman menggunakan state yang sama
/// - **Local Cache**: Daftar favorit disimpan di memori
/// - **Rollback**: Jika operasi gagal, state dikembalikan ke kondisi sebelumnya
class FavoriteProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Local cache untuk daftar favorit
  List<MovieModel> _favorites = [];

  // Set untuk lookup cepat (O(1) instead of O(n))
  Set<int> _favoriteIds = {};

  // Loading state untuk initial load
  bool _isLoading = false;

  // Flag untuk menandakan apakah data sudah di-load
  bool _isInitialized = false;

  // Error message jika ada
  String? _errorMessage;

  // Getters
  List<MovieModel> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  int get favoriteCount => _favorites.length;

  // Get current user ID
  String? get _userId => _supabase.auth.currentUser?.id;

  /// Cek apakah film ada di favorit (O(1) lookup)
  bool isFavorite(int movieId) {
    return _favoriteIds.contains(movieId);
  }

  /// Initialize - load favorites dari server saat pertama kali
  Future<void> initialize() async {
    if (_isInitialized) return;
    await loadFavorites();
  }

  /// Load semua favorit dari Supabase
  Future<void> loadFavorites() async {
    if (_userId == null) {
      _favorites = [];
      _favoriteIds = {};
      _isInitialized = true;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', _userId!)
          .order('created_at', ascending: false);

      _favorites = (response as List)
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

      // Update set untuk lookup cepat
      _favoriteIds = _favorites.map((m) => m.id).toSet();

      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading favorites: $e');
    }
  }

  /// Toggle favorite dengan OPTIMISTIC UPDATE
  ///
  /// Langkah:
  /// 1. Update state lokal DULU (instant feedback)
  /// 2. Kirim request ke server di background
  /// 3. Jika gagal, rollback state lokal
  Future<bool> toggleFavorite(MovieModel movie) async {
    if (_userId == null) {
      _errorMessage = 'User not logged in';
      notifyListeners();
      return false;
    }

    final isCurrentlyFavorite = isFavorite(movie.id);

    // === OPTIMISTIC UPDATE ===
    // Update state lokal PERTAMA (instant feedback ke user)
    if (isCurrentlyFavorite) {
      // Simpan posisi untuk rollback
      final removedIndex = _favorites.indexWhere((m) => m.id == movie.id);
      final removedMovie = _favorites.firstWhere((m) => m.id == movie.id);

      // INSTANT: Hapus dari list lokal
      _favorites.removeWhere((m) => m.id == movie.id);
      _favoriteIds.remove(movie.id);
      notifyListeners(); // UI langsung terupdate!

      // Background: Kirim ke server
      try {
        await _supabase
            .from('favorites')
            .delete()
            .eq('user_id', _userId!)
            .eq('movie_id', movie.id);

        debugPrint('Removed from favorites: ${movie.title}');
        return false; // Tidak favorit lagi
      } catch (e) {
        // ROLLBACK: Kembalikan ke posisi semula jika gagal
        if (removedIndex != -1) {
          _favorites.insert(removedIndex, removedMovie);
        } else {
          _favorites.insert(0, removedMovie);
        }
        _favoriteIds.add(movie.id);
        _errorMessage = 'Failed to remove from favorites';
        notifyListeners();
        debugPrint('Error removing favorite, rolled back: $e');
        return true; // Masih favorit karena gagal dihapus
      }
    } else {
      // INSTANT: Tambah ke list lokal (di posisi awal, terbaru)
      _favorites.insert(0, movie);
      _favoriteIds.add(movie.id);
      notifyListeners(); // UI langsung terupdate!

      // Background: Kirim ke server
      try {
        await _supabase.from('favorites').insert({
          'user_id': _userId,
          'movie_id': movie.id,
          'title': movie.title,
          'poster_path': movie.posterPath,
          'vote_average': movie.voteAverage,
          'release_date': movie.releaseDate,
          'genre_names': movie.genreNamesDisplay,
        });

        debugPrint('Added to favorites: ${movie.title}');
        return true; // Sekarang favorit
      } on PostgrestException catch (e) {
        if (e.code == '23505') {
          // Duplicate - sudah favorit, tidak perlu rollback
          debugPrint('Movie already in favorites (server)');
          return true;
        }
        // ROLLBACK: Hapus dari list lokal jika gagal tambah
        _favorites.removeWhere((m) => m.id == movie.id);
        _favoriteIds.remove(movie.id);
        _errorMessage = 'Failed to add to favorites';
        notifyListeners();
        debugPrint('Error adding favorite, rolled back: $e');
        return false;
      } catch (e) {
        // ROLLBACK: Hapus dari list lokal jika gagal tambah
        _favorites.removeWhere((m) => m.id == movie.id);
        _favoriteIds.remove(movie.id);
        _errorMessage = 'Failed to add to favorites';
        notifyListeners();
        debugPrint('Error adding favorite, rolled back: $e');
        return false;
      }
    }
  }

  /// Tambah ke favorit (dengan optimistic update)
  Future<bool> addFavorite(MovieModel movie) async {
    if (isFavorite(movie.id)) return true; // Sudah favorit
    return await toggleFavorite(movie);
  }

  /// Hapus dari favorit (dengan optimistic update)
  Future<bool> removeFavorite(int movieId) async {
    if (!isFavorite(movieId)) return true; // Sudah tidak favorit

    final movie = _favorites.firstWhere(
      (m) => m.id == movieId,
      orElse: () => MovieModel(
        id: movieId,
        title: '',
        overview: '',
        posterPath: null,
        voteAverage: 0,
        releaseDate: '',
        genreIds: [],
      ),
    );

    if (movie.title.isEmpty) {
      // Movie tidak ditemukan di cache, hapus langsung dari server
      try {
        if (_userId == null) return false;

        await _supabase
            .from('favorites')
            .delete()
            .eq('user_id', _userId!)
            .eq('movie_id', movieId);

        _favoriteIds.remove(movieId);
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint('Error removing favorite: $e');
        return false;
      }
    }

    await toggleFavorite(movie);
    return !isFavorite(movieId);
  }

  /// Clear semua favorit
  Future<void> clearAllFavorites() async {
    if (_userId == null) return;

    // Simpan untuk rollback
    final backupFavorites = List<MovieModel>.from(_favorites);
    final backupIds = Set<int>.from(_favoriteIds);

    // OPTIMISTIC: Clear lokal dulu
    _favorites.clear();
    _favoriteIds.clear();
    notifyListeners();

    try {
      await _supabase.from('favorites').delete().eq('user_id', _userId!);
      debugPrint('All favorites cleared');
    } catch (e) {
      // ROLLBACK
      _favorites = backupFavorites;
      _favoriteIds = backupIds;
      _errorMessage = 'Failed to clear favorites';
      notifyListeners();
      debugPrint('Error clearing favorites, rolled back: $e');
    }
  }

  /// Reset state (dipanggil saat logout)
  void reset() {
    _favorites = [];
    _favoriteIds = {};
    _isLoading = false;
    _isInitialized = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
