import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/home_carousel_models.dart';
import 'package:template_project_flutter/app/pages/wishlist_page.dart';
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
  final TextEditingController searchController = TextEditingController();

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          buildAccount(),
          const SizedBox(height: 32),
          SearchBarInput(
            title: "Type title, categories, years, etc",
            width: double.infinity,
            showFilterIcon: true,
            controller: searchController,
          ),
          const SizedBox(height: 24),
          HomeCarousel(
            items: const [
              HomeCarouselItem(
                imageUrl: 'assets/images/carousel 3.png',
                title: 'Spider-Man: No Way Home',
                subtitle: 'On March 2, 2022',
              ),
              HomeCarouselItem(
                imageUrl: 'assets/images/carousel 2.png',
                title: 'The Batman',
                subtitle: 'On March 2, 2022',
              ),
              HomeCarouselItem(
                imageUrl: 'assets/images/carousel 4.png',
                title: 'Doctor Strange',
                subtitle: 'On March 2, 2022',
              ),
            ],
            initialPage: 1,
          ),
          const SizedBox(height: 24),
          buildCategories(),
          const SizedBox(height: 24),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
        ),
        const SizedBox(height: 15),
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
      ],
    );
  }
}
