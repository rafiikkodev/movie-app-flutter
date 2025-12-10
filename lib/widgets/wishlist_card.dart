import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class WishlistMovieCard extends StatelessWidget {
  final String posterUrl;
  final String title;
  final String year;
  final String genre;
  final String rating;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const WishlistMovieCard({
    super.key,
    required this.posterUrl,
    required this.title,
    required this.year,
    required this.genre,
    required this.rating,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    String formattedRating = rating;
    try {
      final double ratingValue = double.parse(rating);
      formattedRating = ratingValue.toStringAsFixed(1);
    } catch (e) {
      formattedRating = '0.0';
    }

    return Dismissible(
      key: Key(posterUrl + title),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onRemove?.call();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: redColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: whiteColor, size: 32),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(color: softColor),
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: posterUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: darkGreyColor,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: darkBlueAccent,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: softColor,
                      child: Icon(Icons.movie, color: greyColor, size: 50),
                    ),
                  ),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.3, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),

                // Rating badge (top right)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: softColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rate_rounded,
                          color: orangeColor,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formattedRating,
                          style: orangeTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom content (title, year, genre)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Year and Genre
                        Row(
                          children: [
                            Text(
                              year,
                              style: greyTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: medium,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: greyColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                genre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: greyTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
