import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/data/repositories/movie_repository.dart';
import 'package:template_project_flutter/widgets/home_card.dart';
import 'package:template_project_flutter/widgets/home_carousel.dart';
import 'package:template_project_flutter/widgets/inputs.dart';
import 'package:template_project_flutter/widgets/toggle_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieRepository _repository = MovieRepository();
  final TextEditingController searchController = TextEditingController();

  List<MovieModel> nowPlayingMovies = [];
  List<MovieModel> popularMovies = [];
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
            SearchBarInput(
              title: "Search",
              showFilterIcon: true,
              controller: searchController,
              width: double.infinity,
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

            // Success State - Now Playing Carousel
            if (!isLoading && nowPlayingMovies.isNotEmpty)
              HomeCarousel(
                items: nowPlayingMovies.take(5).map((movie) {
                  return HomeCarouselItem(
                    imageUrl: movie.backdropUrl,
                    title: movie.title,
                    subtitle: 'Released: ${movie.releaseDate}',
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
              Image.asset("assets/images/ic-profile-image.png", height: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, Smith",
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
            onTap: () {
              Navigator.pushNamed(context, "/wishlist");
            },
            child: Container(
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
          ),
        ],
      ),
    );
  }

  Widget buildCategories() {
    return CategoryTabs(
      categories: const ['All', 'Action', 'Comedy', 'Drama', 'Horror'],
      initialIndex: 0,
      onCategorySelected: (index, category) {
        // TODO: Filter movies by category
      },
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
            GestureDetector(
              onTap: () {
                // TODO: Navigate to see all
              },
              child: Text(
                "See All",
                style: darkBlueTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                ),
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
                  Navigator.pushNamed(
                    context,
                    "/movie_detail",
                    arguments: movie.id,
                  );
                },
                child: HomeCard(imageUrl: movie.posterUrl, rate: movie.rating),
              );
            },
          ),
        ),
      ],
    );
  }
}
