import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class CustomRate extends StatelessWidget {
  final String number;

  const CustomRate({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: 70,
      decoration: BoxDecoration(
        color: darkColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
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
