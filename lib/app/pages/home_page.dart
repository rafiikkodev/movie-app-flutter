import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/data/repositories/movie_repository.dart';
import 'package:template_project_flutter/app/data/services/auth_service.dart';
import 'package:template_project_flutter/app/pages/movie_detail_page.dart';
import 'package:template_project_flutter/app/pages/wishlist_page.dart';
import 'package:template_project_flutter/widgets/home_card.dart';
import 'package:template_project_flutter/widgets/home_carousel.dart';
import 'package:template_project_flutter/widgets/home_genre_poster_list.dart';
import 'package:template_project_flutter/widgets/toggle_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieRepository _repository = MovieRepository();
  final AuthService _authService = AuthService();

  List<MovieModel> nowPlayingMovies = [];
  List<MovieModel> popularMovies = [];
  String selectedGenre = 'All';
  bool isLoading = true;
  String errorMessage = '';
  int favoriteCount = 0;

  // User data
  String userName = 'User';
  String userEmail = '';
  String? userAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final profile = await _authService.getUserProfile();
        if (mounted) {
          setState(() {
            userEmail = user.email ?? '';
            userName =
                profile?['full_name'] ??
                profile?['username'] ??
                user.userMetadata?['username'] ??
                user.email?.split('@')[0] ??
                'User';
            userAvatarUrl = profile?['avatar_url'];
          });
        }
      }
    } catch (e) {
      // Silent fail - user can still use app
    }
  }

  Future<void> _loadMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final nowPlaying = await _repository.getNowPlayingMovies();
      final popular = await _repository.getPopularMovies();

      setState(() {
        nowPlayingMovies = nowPlaying;
        popularMovies = popular;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadMovies,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            buildAccount(),
            const SizedBox(height: 24),

            // Loading State
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: CircularProgressIndicator(),
                ),
              ),

            // Error State
            if (errorMessage.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Text(
                        'Error: $errorMessage',
                        style: whiteTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadMovies,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),

            // Success State - Now Playing Carousel
            if (!isLoading && nowPlayingMovies.isNotEmpty)
              HomeCarousel(
                items: nowPlayingMovies.take(5).map((movie) {
                  return HomeCarouselItem(
                    imageUrl: movie.backdropUrl,
                    title: movie.title,
                    subtitle: 'Released: ${movie.releaseDate}',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(movie: movie),
                        ),
                      );
                    },
                  );
                }).toList(),
                initialPage: 1,
              ),

            const SizedBox(height: 24),
            buildCategories(),
            const SizedBox(height: 24),

            // Popular Movies Section
            if (!isLoading && popularMovies.isNotEmpty) buildMostPopular(),
          ],
        ),
      ),
    );
  }

  Widget buildAccount() {
    return Container(
      margin: const EdgeInsets.only(top: 52),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Avatar with network image
              userAvatarUrl != null && userAvatarUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: userAvatarUrl!,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: darkGreyColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: darkBlueAccent,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/ic-profile-image.png",
                          height: 40,
                        ),
                      ),
                    )
                  : Image.asset(
                      "assets/images/ic-profile-image.png",
                      height: 40,
                    ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, $userName",
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                    ),
                  ),
                  Text(
                    "Let's stream your favorite movie",
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const WishlistPage(showBackButton: true),
                ),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: softColor,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons-blue-accent/heart.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Genres",
              style: whiteTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        CategoryTabs(
          categories: const [
            'All',
            'Action',
            'Adventure',
            'Animation',
            'Comedy',
            'Crime',
            'Documentary',
            'Drama',
            'Family',
            'Fantasy',
            'History',
            'Horror',
            'Music',
            'Mystery',
            'Romance',
            'Sci-Fi',
            'TV Movie',
            'Thriller',
            'War',
            'Western',
          ],
          initialIndex: 0,
          onCategorySelected: (index, category) {
            setState(() {
              selectedGenre = category;
            });
          },
        ),
        const SizedBox(height: 16),
        GenrePosterList(
          movies: nowPlayingMovies,
          genre: selectedGenre,
          onMovieTap: (movie) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailPage(movie: movie),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildMostPopular() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Most Popular",
              style: whiteTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 231,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: popularMovies.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = popularMovies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
                child: HomeCard(
                  imageUrl: movie.posterUrl,
                  voteAverage: movie.voteAverage.toString(),
                  title: movie.title,
                  genreIds: movie.genreNamesDisplay,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
