import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class HomeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subTitle;
  // final String url;

  const HomeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    // required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // tambahkan ini agar bisa dipencet
      // onTap: () async {
      //   // link ke url ketuju
      //   if (await canLaunchUrl(Uri.parse(url))) {
      //     launchUrl(Uri.parse(url));
      //   }
      // },
      child: Container(
        width: 135,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: softColor,
        ),
        child: Column(
          children: [
            ClipRRect(
              // widget anaknya punya border radius
              borderRadius: const BorderRadiusDirectional.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                imageUrl,
                width: 135,
                height: 178,
                fit: BoxFit.cover,
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
                      overflow: TextOverflow
                          .ellipsis, // jika title melebihi akan ada titik titik
                    ),
                    maxLines: 1, // jumlah baris ada 2
                  ),
                  SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: greyTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 10,
                      overflow: TextOverflow
                          .ellipsis, // jika title melebihi akan ada titik titik
                    ),
                    maxLines: 1, // jumlah baris ada 2
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
