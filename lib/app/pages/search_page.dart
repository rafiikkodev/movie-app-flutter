import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/data/repositories/movie_repository.dart';
import 'package:template_project_flutter/app/pages/movie_detail_page.dart';
import 'package:template_project_flutter/app/pages/search_result_page.dart';
import 'package:template_project_flutter/widgets/home_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final MovieRepository _repository = MovieRepository();

  List<MovieModel> upcomingMovies = [];
  List<MovieModel> topRatedMovies = [];
  List<MovieModel> popularMovies = [];
  List<MovieModel> nowPlayingMovies = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final results = await Future.wait([
        _repository.getUpcomingMovies(),
        _repository.getTopRatedMovies(),
        _repository.getPopularMovies(),
        _repository.getNowPlayingMovies(),
      ]);

      setState(() {
        upcomingMovies = results[0];
        topRatedMovies = results[1];
        popularMovies = results[2];
        nowPlayingMovies = results[3];
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
          padding: const EdgeInsets.only(right: 24, left: 24, top: 52),
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(56),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchResultPage(),
                  ),
                );
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: softColor,
                  borderRadius: BorderRadius.circular(56),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: greyColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Search movies...",
                        style: TextStyle(
                          color: greyColor,
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

            // Success State
            if (!isLoading && errorMessage.isEmpty) ...[
              buildRecommend(),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildRecommend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommend for you",
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
        ),
        const SizedBox(height: 15),

        // Row 1: Top Rated Movies
        _buildMovieRow(topRatedMovies),
        const SizedBox(height: 15),

        // Row 2: Popular Movies
        _buildMovieRow(popularMovies),
        const SizedBox(height: 15),

        // Row 3: Now Playing Movies
        _buildMovieRow(nowPlayingMovies),
      ],
    );
  }

  Widget _buildMovieRow(List<MovieModel> movies) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 231,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
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
              genreIds: movie.genreNames,
            ),
          );
        },
      ),
    );
  }
}

// Custom SearchCard widget
class _SearchCard extends StatelessWidget {
  final String imageUrl;
  final String year;
  final String rating;
  final String genre;
  final String title;

  const _SearchCard({
    required this.imageUrl,
    required this.year,
    required this.rating,
    required this.genre,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Movie Poster
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.network(
              imageUrl,
              width: 110,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 110,
                  height: 160,
                  color: darkGreyColor,
                  child: Icon(Icons.movie, color: greyColor, size: 40),
                );
              },
            ),
          ),
          // Movie Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: whiteTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        genre,
                        style: greyTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: greyColor),
                      const SizedBox(width: 4),
                      Text(
                        year,
                        style: greyTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.star, size: 14, color: darkBlueAccent),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
