import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class CustomFillRate extends StatelessWidget {
  final String number;

  const CustomFillRate({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: softColor.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_rate_rounded, color: orangeColor),
          SizedBox(width: 4),
          Text(
            number,
            style: orangeTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
          ),
        ],
      ),
    );
  }
}

class CustomTextRate extends StatelessWidget {
  final String number;

  const CustomTextRate({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_rate_rounded, color: orangeColor),
          SizedBox(width: 4),
          Text(
            number,
            style: orangeTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
          ),
        ],
      ),
    );
  }
}
