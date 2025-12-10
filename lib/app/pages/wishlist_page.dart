import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/pages/movie_detail_page.dart';
import 'package:template_project_flutter/app/services/favorite_service.dart';
import 'package:template_project_flutter/widgets/app_bar.dart';
import 'package:template_project_flutter/widgets/wishlist_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final FavoriteService _favoriteService = FavoriteService();
  List<MovieModel> _favoriteMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final favorites = await _favoriteService.getFavorites();

      setState(() {
        _favoriteMovies = favorites;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('WishlistPage: Error loading favorites: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(int movieId) async {
    await _favoriteService.removeFavorite(movieId);
    await _loadFavorites();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Removed from favorites',
            style: whiteTextStyle.copyWith(fontSize: 14),
          ),
          backgroundColor: darkBlueAccent,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomAppBar(showBackButton: true, title: "My Wishlist"),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            sliver: _isLoading
                ? SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: darkBlueAccent),
                    ),
                  )
                : _favoriteMovies.isEmpty
                ? SliverFillRemaining(child: _buildEmptyState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final movie = _favoriteMovies[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < _favoriteMovies.length - 1 ? 16 : 0,
                        ),
                        child: _buildMovieCard(movie),
                      );
                    }, childCount: _favoriteMovies.length),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: greyColor),
          const SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: whiteTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start adding movies to your wishlist by tapping the heart icon',
              style: greyTextStyle.copyWith(fontSize: 14, fontWeight: medium),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: darkBlueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(56),
              ),
            ),
            child: Text(
              'Browse Movies',
              style: whiteTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie) {
    return WishlistMovieCard(
      posterUrl: movie.posterUrl,
      title: movie.title,
      year: movie.year,
      genre: movie.genreNames.split(', ').take(2).join(' • '),
      rating: movie.voteAverage.toString(),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie),
          ),
        );
        // Reload favorites when returning from detail page
        _loadFavorites();
      },
      onRemove: () {
        _removeFavorite(movie.id);
      },
    );
  }
}
