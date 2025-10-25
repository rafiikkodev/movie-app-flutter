import 'package:flutter/material.dart';
import 'package:template_project_flutter/widgets/download_card.dart';
import 'package:template_project_flutter/widgets/app_bar.dart';
import 'package:template_project_flutter/widgets/wishlist_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CustomAppBar(showBackButton: true, title: "Wishlist"),
        SliverPadding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: WishlistCard(
                  imageUrl: "assets/images/card2.png",
                  genre: "Action • Adventure",
                  title: "Spider-Man: No Way Home",
                  rate: "4.8",
                ),
              );
            }, childCount: 10),
          ),
        ),
      ],
    );
  }
}
