import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/widgets/buttons.dart';
import 'package:template_project_flutter/widgets/home_card.dart';
import 'package:template_project_flutter/widgets/inputs.dart';
import 'package:template_project_flutter/widgets/toggle_buttons.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(right: 24, left: 24, top: 52),
        children: [
          SearchBarInput(
            title: "Type title, categories, years, etc",
            width: double.infinity,
            showFilterIcon: false,
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
        SizedBox(
          height: 147,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchCard(imageUrl: "assets/images/card.png", rate: '4.8'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton.primary(
                    title: "Premium",
                    width: 70,
                    fontSize: 10,
                    size: ButtonSize.extraSmall,
                  ),
                  Text(
                    "Spider-Man No Way Home",
                    style: whiteTextStyle.copyWith(
                      fontWeight: semiBold,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/icons-white/calendar.svg',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "2021",
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons-white/clock.svg',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "148 Minutes",
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                      ),
                      SizedBox(width: 12),
                      CustomButton.outlined(
                        title: "PG-13",
                        width: 84,
                        fontSize: 12,
                        size: ButtonSize.extraSmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons-white/film.svg',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Action | Movie",
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
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
              HomeCard(
                imageUrl: "assets/images/card.png",
                title: "Spider-Man No Way Home",
                subTitle: 'Action',
                rate: '4.8',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card1.png",
                title: "Eternals",
                subTitle: 'Action',
                rate: '4.5',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card2.png",
                title: "Venom",
                subTitle: 'Action',
                rate: '4.7',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card.png",
                title: "Shang-Chi",
                subTitle: 'Action',
                rate: '4.9',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card1.png",
                title: "Black Widow",
                subTitle: 'Action',
                rate: '4.6',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card2.png",
                title: "Dune",
                subTitle: 'Sci-Fi',
                rate: '4.8',
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              HomeCard(
                imageUrl: "assets/images/card.png",
                title: "Spider-Man No Way Home",
                subTitle: 'Action',
                rate: '4.8',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card1.png",
                title: "Eternals",
                subTitle: 'Action',
                rate: '4.5',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card2.png",
                title: "Venom",
                subTitle: 'Action',
                rate: '4.7',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card.png",
                title: "Shang-Chi",
                subTitle: 'Action',
                rate: '4.9',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card1.png",
                title: "Black Widow",
                subTitle: 'Action',
                rate: '4.6',
              ),
              SizedBox(width: 12),
              HomeCard(
                imageUrl: "assets/images/card2.png",
                title: "Dune",
                subTitle: 'Sci-Fi',
                rate: '4.8',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
