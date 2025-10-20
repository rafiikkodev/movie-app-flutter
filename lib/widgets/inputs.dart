import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class SearchBarInput extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final bool showFilterIcon;
  final VoidCallback? onPressed;

  const SearchBarInput({
    super.key,
    required this.title,
    required this.width,
    this.height = 40,
    this.showFilterIcon = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: softColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.search, color: greyColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
            if (showFilterIcon) ...[
              Row(
                children: [
                  VerticalDivider(
                    color: greyColor,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    child: Icon(Icons.filter_list, color: whiteColor, size: 24),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  // OOP
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const EmailInput({
    super.key,
    required this.title,
    required this.width,
    // this.width = double.infinity,
    this.height = 40,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: softColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
          alignment: AlignmentDirectional.centerStart,
        ),
        child: Text(
          title,
          style: greyTextStyle.copyWith(fontSize: 12, fontWeight: medium),
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  // OOP
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const PasswordInput({
    super.key,
    required this.title,
    required this.width,
    // this.width = double.infinity,
    this.height = 40,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: softColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: whiteTextStyle.copyWith(fontSize: 12, fontWeight: medium),
            ),
            Icon(Icons.remove_red_eye_outlined, color: whiteColor),
          ],
        ),
      ),
    );
  }
}

class NumberInput extends StatelessWidget {
  // OOP
  final String title;
  final String number;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const NumberInput({
    super.key,
    required this.title,
    required this.number,
    required this.width,
    // this.width = double.infinity,
    this.height = 40,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: softColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.flag_circle_rounded, color: greyColor),
                SizedBox(width: 4),
                Text(
                  number,
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
                VerticalDivider(
                  color: greyColor,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                ),
                Text(
                  title,
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
