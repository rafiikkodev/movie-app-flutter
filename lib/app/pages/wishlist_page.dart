import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/data/providers/favorite_provider.dart';
import 'package:template_project_flutter/app/pages/movie_detail_page.dart';
import 'package:template_project_flutter/widgets/app_bar.dart';
import 'package:template_project_flutter/widgets/wishlist_card.dart';

class WishlistPage extends StatefulWidget {
  final bool showBackButton;

  const WishlistPage({super.key, this.showBackButton = false});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    // Initialize favorites jika belum diinisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FavoriteProvider>();
      if (!provider.isInitialized) {
        provider.initialize();
      }
    });
  }

  void _removeFavorite(MovieModel movie) {
    final provider = context.read<FavoriteProvider>();
    provider.toggleFavorite(movie);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Removed from favorites',
          style: whiteTextStyle.copyWith(fontSize: 14),
        ),
        backgroundColor: darkBlueAccent,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: whiteColor,
          onPressed: () {
            // Re-add to favorites (optimistic update akan mengembalikannya)
            provider.toggleFavorite(movie);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final favoriteMovies = favoriteProvider.favorites;
        final isLoading =
            favoriteProvider.isLoading && !favoriteProvider.isInitialized;

        return CustomScrollView(
          slivers: [
            CustomAppBar(
              showBackButton: widget.showBackButton,
              title: "My Wishlist",
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              sliver: isLoading
                  ? SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: darkBlueAccent),
                      ),
                    )
                  : favoriteMovies.isEmpty
                  ? SliverFillRemaining(child: _buildEmptyState())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final movie = favoriteMovies[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < favoriteMovies.length - 1 ? 16 : 0,
                          ),
                          child: _buildMovieCard(movie),
                        );
                      }, childCount: favoriteMovies.length),
                    ),
            ),
          ],
        );
      },
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
        ],
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie) {
    return WishlistMovieCard(
      posterUrl: movie.posterUrl,
      title: movie.title,
      year: movie.year,
      genre: movie.genreNamesDisplay.split(', ').take(2).join(' • '),
      rating: movie.voteAverage.toString(),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie),
          ),
        );
        // Tidak perlu reload - state sudah shared via Provider
      },
      onRemove: () {
        _removeFavorite(movie);
      },
    );
  }
}
