import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class CustomTags extends StatelessWidget {
  final String title;

  const CustomTags({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
          ),
          const SizedBox(width: 8),
          Icon(Icons.favorite_border_rounded, color: whiteColor, size: 18),
        ],
      ),
    );
  }
}
