import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/widgets/home_carousel.dart';
import 'package:template_project_flutter/widgets/inputs.dart';
import 'package:template_project_flutter/widgets/toggle_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          buildAccount(),
          SizedBox(height: 32),
          SearchBarInput(title: "Search a title...", width: double.infinity),
          SizedBox(height: 24),
          ImageCarousel(
            images: [
              'assets/images/carousel 3.png',
              'assets/images/carousel 2.png',
              'assets/images/carousel 4.png',
            ],
            initialPage: 1,
          ),
          SizedBox(height: 24),
          buildCategories(),
          SizedBox(height: 24),
          buildMostPopular(),
        ],
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
              SizedBox(width: 16),
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
                    "Let’s stream your favorite movie",
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    );
  }

  Widget buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
        ),
        SizedBox(height: 15),
        CategoryTabs(
          categories: const [
            'Tab Active',
            'Tab Inactive',
            'Tab Inactive',
            'Tab Inactive',
            'Another Tab',
          ],
          initialIndex: 0,
          onCategorySelected: (index, category) {},
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
              "Categories",
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
        SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Image.asset("assets/images/Card.png"),
              SizedBox(width: 12),
              Image.asset("assets/images/Card-1.png"),
              SizedBox(width: 12),
              Image.asset("assets/images/Card-2.png"),
              SizedBox(width: 12),
              Image.asset("assets/images/Card-1.png"),
              SizedBox(width: 12),
              Image.asset("assets/images/Card-2.png"),
              SizedBox(width: 12),
              Image.asset("assets/images/Card-1.png"),
              SizedBox(width: 12),
              Image.asset("assets/images/Card-2.png"),
            ],
          ),
        ),
      ],
    );
  }
}
