import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/widgets/rate.dart';

class WishlistCard extends StatelessWidget {
  final String imageUrl;
  final String genre;
  final String title;
  final String rate;

  const WishlistCard({
    super.key,
    required this.imageUrl,
    required this.genre,
    required this.title,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: softColor,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              width: 121,
              height: 83,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  genre,
                  style: whiteTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextRate(number: rate),
                    SvgPicture.asset(
                      'assets/icons-blue-accent/heart.svg',
                      width: 24,
                      height: 24,
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

// usage

// app bar + bg
// Scaffold(
//   appBar: const CustomAppBar(
//     title: "Detail Film",
//     showFavoriteButton: true,
//     isSticky: true, // tetap ada + background color
//   ),
//   body: ListView(
//     children: [
//       ... // konten panjang
//     ],
//   ),
// );

// app bar hilang saat scroll
// CustomScrollView(
//   slivers: [
//     SliverToBoxAdapter(
//       child: CustomAppBar(
//         title: "Detail Film",
//         isSticky: false, // akan hilang saat scroll
//       ),
//     ),
//     SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (context, index) => ListTile(title: Text("Item $index")),
//         childCount: 30,
//       ),
//     ),
//   ],
// );
