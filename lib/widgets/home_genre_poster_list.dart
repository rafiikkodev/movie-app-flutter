import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/widgets/rate.dart';

class GenrePosterList extends StatelessWidget {
  final List<MovieModel> movies;
  final String genre;
  final VoidCallback? onTap;

  const GenrePosterList({
    super.key,
    required this.movies,
    required this.genre,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = genre == 'All'
        ? movies
        : movies
              .where(
                (m) => m.genreNames.toLowerCase().contains(genre.toLowerCase()),
              )
              .toList();

    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No $genre movies found',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 231,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filtered.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = filtered[index];
          String formattedRating = movie.rating;
          try {
            final double rating = double.parse(movie.rating);
            formattedRating = rating.toStringAsFixed(1);
          } catch (e) {
            formattedRating = '0.0';
          }

          return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 135,
                height: 231,
                decoration: BoxDecoration(color: softColor),
                child: Stack(
                  children: [
                    // Image
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: movie.posterUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: darkBlueAccent,
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: softColor,
                          child: Icon(Icons.movie, color: greyColor, size: 50),
                        ),
                      ),
                    ),
                    // Rating
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CustomFillRate(number: formattedRating),
                    ),
                    // Title & Genre
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: darkColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: whiteTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semiBold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              movie.genreNames,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: whiteTextStyle.copyWith(
                                fontSize: 10,
                                fontWeight: regular,
                                color: greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
