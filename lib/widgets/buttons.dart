import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

/// ukuran button
enum ButtonSize {
  extraLarge(56),
  large(52),
  medium(44),
  small(36),
  extraSmall(28);

  final double height;
  const ButtonSize(this.height);
}

/// style button
enum ButtonVariant {
  primary,
  outlined,
  text,
  disabled,
  primaryIcon,
  outlinedIcon,
}

/// custom beberapa varian dan ukuran
class CustomButton extends StatelessWidget {
  final String title;
  final ButtonSize size;
  final ButtonVariant variant;
  final double width;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.title,
    required this.width,
    this.size = ButtonSize.large,
    this.variant = ButtonVariant.primary,
    this.onPressed,
  });

  // factory constructors untuk kemudahan penggunaan
  factory CustomButton.primary({
    required String title,
    required double width,
    ButtonSize size = ButtonSize.large,
    VoidCallback? onPressed,
  }) {
    return CustomButton(
      title: title,
      width: width,
      size: size,
      variant: ButtonVariant.primary,
      onPressed: onPressed,
    );
  }

  factory CustomButton.outlined({
    required String title,
    required double width,
    ButtonSize size = ButtonSize.large,
    VoidCallback? onPressed,
  }) {
    return CustomButton(
      title: title,
      width: width,
      size: size,
      variant: ButtonVariant.outlined,
      onPressed: onPressed,
    );
  }

  factory CustomButton.text({
    required String title,
    required double width,
    ButtonSize size = ButtonSize.large,
    VoidCallback? onPressed,
  }) {
    return CustomButton(
      title: title,
      width: width,
      size: size,
      variant: ButtonVariant.text,
      onPressed: onPressed,
    );
  }

  factory CustomButton.disabled({
    required String title,
    required double width,
    ButtonSize size = ButtonSize.large,
    VoidCallback? onPressed,
  }) {
    return CustomButton(
      title: title,
      width: width,
      size: size,
      variant: ButtonVariant.disabled,
      onPressed: onPressed,
    );
  }

  factory CustomButton.primaryIcon({
    required String title,
    required double width,
    ButtonSize size = ButtonSize.large,
    VoidCallback? onPressed,
  }) {
    return CustomButton(
      title: title,
      width: width,
      size: size,
      variant: ButtonVariant.primaryIcon,
      onPressed: onPressed,
    );
  }

  factory CustomButton.outlinedIcon({
    required String title,
    required double width,
    ButtonSize size = ButtonSize.large,
    VoidCallback? onPressed,
  }) {
    return CustomButton(
      title: title,
      width: width,
      size: size,
      variant: ButtonVariant.outlinedIcon,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: size.height, child: _buildButton());
  }

  Widget _buildButton() {
    switch (variant) {
      case ButtonVariant.primary:
        return _buildPrimaryButton();
      case ButtonVariant.outlined:
        return _buildOutlinedButton();
      case ButtonVariant.text:
        return _buildTextButton();
      case ButtonVariant.disabled:
        return _buildDisabledButton();
      case ButtonVariant.primaryIcon:
        return _buildPrimaryIconButton();
      case ButtonVariant.outlinedIcon:
        return _buildOutlinedIconButton();
    }
  }

  Widget _buildPrimaryButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: darkBlueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: Text(
        title,
        style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        side: BorderSide(color: darkBlueAccent, width: 1.5),
      ),
      child: Text(
        title,
        style: darkBlueTextStyle.copyWith(fontSize: 16, fontWeight: medium),
      ),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Text(title, style: darkBlueTextStyle.copyWith(fontSize: 16)),
    );
  }

  Widget _buildDisabledButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: darkGreyColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: Text(
        title,
        style: greyTextStyle.copyWith(fontSize: 16, fontWeight: medium),
      ),
    );
  }

  Widget _buildPrimaryIconButton() {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: darkBlueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_arrow, color: whiteColor,),
          SizedBox(width: 8),
          Text(
            title,
            style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedIconButton() {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        side: BorderSide(color: darkBlueAccent, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_arrow, color: darkBlueAccent,),
          SizedBox(width: 8),
          Text(
            title,
            style: darkBlueTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
        ],
      ),
    );
  }
}
