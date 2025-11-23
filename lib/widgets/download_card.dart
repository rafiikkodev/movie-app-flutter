import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class DownloadCard extends StatelessWidget {
  final String imageUrl;
  final String genre;
  final String title;
  final String download;
  final VoidCallback? onTap;

  const DownloadCard({
    super.key,
    required this.imageUrl,
    required this.genre,
    required this.title,
    required this.download,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  Text(
                    download,
                    style: greyTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
