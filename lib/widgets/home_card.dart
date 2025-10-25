import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/widgets/buttons.dart';
import 'package:template_project_flutter/widgets/rate.dart';

class HomeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subTitle;
  final String rate;

  const HomeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: softColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadiusDirectional.vertical(
              top: Radius.circular(12),
            ),
            child: SizedBox(
              width: 135,
              height: 178,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(top: 8, right: 8, child: CustomRate(number: rate)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: whiteTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: greyTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String year;
  final String duration;
  final String rating;
  final String genre;
  final String rate;
  final VoidCallback? onTap;

  const SearchCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.year,
    required this.duration,
    required this.rating,
    required this.genre,
    required this.rate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie poster
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 112,
              height: 147,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned(top: 8, left: 8, child: CustomRate(number: rate)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Movie details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Premium badge
                CustomButton.primary(
                  title: "Premium",
                  width: 70,
                  fontSize: 10,
                  size: ButtonSize.extraSmall,
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  title,
                  style: whiteTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Year
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons-white/calendar.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      year,
                      style: greyTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Duration and Rating
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons-white/clock.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: greyTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: darkBlueAccent, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        rating,
                        style: darkBlueTextStyle.copyWith(
                          fontSize: 10,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Genre
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons-white/film.svg',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        genre,
                        style: greyTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
