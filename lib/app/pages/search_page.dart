import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/pages/search_result_page.dart';
import 'package:template_project_flutter/widgets/home_card.dart';
import 'package:template_project_flutter/widgets/toggle_buttons.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(right: 24, left: 24, top: 52),
        children: [
          // SearchBarInput(
          //   width: double.infinity,
          //   showFilterIcon: false,
          //   controller: searchController,
          // ),
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
          buildCategories(),
          SizedBox(height: 24),
          buildToday(),
          SizedBox(height: 24),
          buildRecommend(),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryTabs(
          categories: const [
            'All',
            'Action',
            'Comedy',
            'Drama',
            'Horror',
            'Action',
            'Comedy',
            'Drama',
            'Horror',
          ],
          initialIndex: 0,
          onCategorySelected: (index, category) {},
        ),
      ],
    );
  }

  Widget buildToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Most Popular",
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          textAlign: TextAlign.left,
        ),

        SizedBox(height: 16),
        SearchCard(
          imageUrl: "assets/images/card.png",
          year: "year",
          duration: "duration",
          rating: "rating",
          genre: 'genre',
          rate: "rate",
          title: '',
        ),
      ],
    );
  }

  Widget buildRecommend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recommend for you",
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
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              HomeCard(imageUrl: "assets/images/card.png", rate: '4.8'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card1.png", rate: '4.5'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card2.png", rate: '4.7'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card.png", rate: '4.9'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card1.png", rate: '4.6'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card2.png", rate: '4.8'),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              HomeCard(imageUrl: "assets/images/card.png", rate: '4.8'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card1.png", rate: '4.5'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card2.png", rate: '4.7'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card.png", rate: '4.9'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card1.png", rate: '4.6'),
              SizedBox(width: 12),
              HomeCard(imageUrl: "assets/images/card2.png", rate: '4.8'),
            ],
          ),
        ),
      ],
    );
  }
}
