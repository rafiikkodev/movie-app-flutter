import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/pages/movie_detail_page.dart';
import 'package:template_project_flutter/app/pages/search_by_actor_page.dart';
import 'package:template_project_flutter/widgets/home_card.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchByActorPage(),
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
          buildSearchResult(),
        ],
      ),
    );
  }

  Widget buildSearchResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(7, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: index < 6 ? 16 : 0),
                child: SearchCard(
                  imageUrl: "assets/images/card.png",
                  title: "title",
                  year: "year",
                  duration: "duration",
                  rating: "rating",
                  genre: 'genre',
                  rate: "rate",
                  onTap: () {
                    // TODO: Pass real movie data when search is implemented
                    final dummyMovie = MovieModel(
                      id: index + 1,
                      title: "title",
                      overview: "No overview available",
                      voteAverage: 0.0,
                      releaseDate: "year",
                      genreIds: [],
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailPage(movie: dummyMovie),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
