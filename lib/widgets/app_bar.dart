import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class CustomAppBar extends StatelessWidget {
  final bool showBackButton;
  final bool showFavoriteButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onFavoritePressed;
  final bool isFavorite;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.showFavoriteButton = false,
    this.onBackPressed,
    this.onFavoritePressed,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 52),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol back
            if (showBackButton)
              _buildButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            else
              const SizedBox(width: 48),

            // Tombol favorite (optional)
            if (showFavoriteButton)
              _buildButton(
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : whiteColor,
                onPressed: onFavoritePressed,
              )
            else
              const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: darkColor, shape: BoxShape.circle),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(icon, color: color ?? whiteColor, size: 20),
          ),
        ),
      ),
    );
  }
}
