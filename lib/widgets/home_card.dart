import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
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
