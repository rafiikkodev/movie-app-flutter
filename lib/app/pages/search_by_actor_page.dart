import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/pages/movie_detail_page.dart';
import 'package:template_project_flutter/widgets/home_card.dart';

class SearchByActorPage extends StatefulWidget {
  const SearchByActorPage({super.key});

  @override
  State<SearchByActorPage> createState() => _SearchByActorPageState();
}

class _SearchByActorPageState extends State<SearchByActorPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(right: 24, left: 24, top: 52),
        children: [
          // SearchBarInputResult(
          //   title: "Type title, categories, years, etc",
          //   showFilterIcon: false,
          //   controller: searchController,
          // ),
          InkWell(
            borderRadius: BorderRadius.circular(56),
            onTap: () {
              // TODO: Implement search functionality
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MovieDetailPage(movie: movieModel),
              //   ),
              // );
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
                      "title",
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
          SizedBox(height: 24),
          buildActors(),
          SizedBox(height: 24),
          buildMovieRelated(),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget buildActors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Image.asset("assets/images/actors.png", height: 64),
                      SizedBox(height: 8),
                      Text(
                        "nama lengkap",
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: semiBold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Column(
                    children: [
                      Image.asset("assets/images/actors.png", height: 64),
                      SizedBox(height: 8),
                      Text(
                        "nama lengkap",
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: semiBold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Column(
                    children: [
                      Image.asset("assets/images/actors.png", height: 64),
                      SizedBox(height: 8),
                      Text(
                        "nama lengkap",
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: semiBold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Column(
                    children: [
                      Image.asset("assets/images/actors.png", height: 64),
                      SizedBox(height: 8),
                      Text(
                        "nama lengkap",
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: semiBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMovieRelated() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Movie Related",
              style: whiteTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            Text(
              "See All",
              style: darkBlueTextStyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SearchCard(
                imageUrl: "assets/images/card.png",
                title: "title",
                year: "year",
                duration: "duration",
                rating: "rating",
                genre: 'genre',
                rate: "rate",
                onTap: () {
                  // TODO: Pass real movie data when available
                  // Create dummy movie for now
                  final dummyMovie = MovieModel(
                    id: 1,
                    title: "title",
                    overview: "No overview available",
                    voteAverage: 0.0,
                    releaseDate: "year",
                    genreIds: [],
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: dummyMovie),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SearchCard(
                imageUrl: "assets/images/card.png",
                title: "title",
                year: "year",
                duration: "duration",
                rating: "rating",
                genre: 'genre',
                rate: "rate",
                onTap: () {
                  final dummyMovie = MovieModel(
                    id: 3,
                    title: "title",
                    overview: "No overview available",
                    voteAverage: 0.0,
                    releaseDate: "year",
                    genreIds: [],
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: dummyMovie),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SearchCard(
                imageUrl: "assets/images/card.png",
                title: "title",
                year: "year",
                duration: "duration",
                rating: "rating",
                genre: 'genre',
                rate: "rate",
                onTap: () {
                  final dummyMovie = MovieModel(
                    id: 4,
                    title: "title",
                    overview: "No overview available",
                    voteAverage: 0.0,
                    releaseDate: "year",
                    genreIds: [],
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: dummyMovie),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SearchCard(
                imageUrl: "assets/images/card.png",
                title: "title",
                year: "year",
                duration: "duration",
                rating: "rating",
                genre: 'genre',
                rate: "rate",
                onTap: () {
                  final dummyMovie = MovieModel(
                    id: 5,
                    title: "title",
                    overview: "No overview available",
                    voteAverage: 0.0,
                    releaseDate: "year",
                    genreIds: [],
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: dummyMovie),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SearchCard(
                imageUrl: "assets/images/card.png",
                title: "title",
                year: "year",
                duration: "duration",
                rating: "rating",
                genre: 'genre',
                rate: "rate",
                onTap: () {
                  final dummyMovie = MovieModel(
                    id: 6,
                    title: "title",
                    overview: "No overview available",
                    voteAverage: 0.0,
                    releaseDate: "year",
                    genreIds: [],
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: dummyMovie),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SearchCard(
                imageUrl: "assets/images/card.png",
                title: "title",
                year: "year",
                duration: "duration",
                rating: "rating",
                genre: 'genre',
                rate: "rate",
                onTap: () {
                  final dummyMovie = MovieModel(
                    id: 7,
                    title: "title",
                    overview: "No overview available",
                    voteAverage: 0.0,
                    releaseDate: "year",
                    genreIds: [],
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: dummyMovie),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SearchCard(
                imageUrl: "assets/images/card.png",
                title: "title",
                year: "year",
                duration: "duration",
                rating: "rating",
                genre: 'genre',
                rate: "rate",
                onTap: () {
                  final dummyMovie = MovieModel(
                    id: 8,
                    title: "title",
                    overview: "No overview available",
                    voteAverage: 0.0,
                    releaseDate: "year",
                    genreIds: [],
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: dummyMovie),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
