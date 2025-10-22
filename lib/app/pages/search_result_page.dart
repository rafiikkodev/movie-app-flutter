import 'package:flutter/material.dart';
import 'package:template_project_flutter/widgets/home_card.dart';
import 'package:template_project_flutter/widgets/inputs.dart';

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
          SearchBarInputResult(
            title: "Type title, categories, years, etc",
            showFilterIcon: false,
            controller: searchController,
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
            children: [
              SearchCard(
                imageUrl: "assets/images/card.png",
                title: "title",
                year: "year",
                duration: "duration",
                rating: "rating",
                genre: 'genre',
                rate: "rate",
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
