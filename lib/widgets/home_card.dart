import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/widgets/buttons.dart';
import 'package:template_project_flutter/widgets/rate.dart';

class HomeCard extends StatelessWidget {
  final String imageUrl;
  final String rate;
  final VoidCallback? onTap;

  const HomeCard({
    super.key,
    required this.imageUrl,
    required this.rate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 135,
          height: 231,
          decoration: BoxDecoration(
            color: softColor,
          ),
          child: Stack(
            children: [
              // Network Image dengan cache
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: darkBlueAccent,
                      strokeWidth: 2,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: softColor,
                    child: Icon(
                      Icons.movie,
                      color: greyColor,
                      size: 50,
                    ),
                  ),
                ),
              ),
              // Rating badge
              Positioned(
                top: 8,
                right: 8,
                child: CustomFillRate(number: rate),
              ),
            ],
          ),
        ),
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
                  Positioned(top: 8, left: 8, child: CustomFillRate(number: rate)),
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
