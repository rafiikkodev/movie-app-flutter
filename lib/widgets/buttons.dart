import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

// BUTTON DENGAN BACKGROUND

class PrimaryExtraLargeLabelButton extends StatelessWidget {
  // OOP
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const PrimaryExtraLargeLabelButton({
    super.key,
    required this.title,
    required this.width,
    // this.width = double.infinity,
    this.height = 56,
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
          backgroundColor: darkBlueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          title,
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ),
    );
  }
}

class PrimaryLargeLabelButton extends StatelessWidget {
  // OOP
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const PrimaryLargeLabelButton({
    super.key,
    required this.title,
    required this.width,
    // this.width = double.infinity,
    this.height = 52,
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
          backgroundColor: darkBlueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          title,
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ),
    );
  }
}

class PrimarySmallLabelButton extends StatelessWidget {
  // OOP
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const PrimarySmallLabelButton({
    super.key,
    required this.title,
    required this.width,
    // this.width = double.infinity,
    this.height = 36,
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
          backgroundColor: darkBlueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          title,
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ),
    );
  }
}

class PrimaryExtraSmallLabelButton extends StatelessWidget {
  // OOP
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const PrimaryExtraSmallLabelButton({
    super.key,
    required this.title,
    required this.width,
    // this.width = double.infinity,
    this.height = 28,
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
          backgroundColor: darkBlueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          title,
          style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ),
    );
  }
}

// BUTTON DENGAN STROKE

class DefaultExtraLargeLabelButton extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final VoidCallback? onPressed;

  const DefaultExtraLargeLabelButton({
    super.key,
    required this.title,
    // this.width = double.infinity,
    required this.width,
    this.height = 56,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          side: BorderSide(
            color: darkBlueAccent,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        onPressed: () {},
        child: Text(
          title,
          style: darkBlueTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ),
    );
  }
}
