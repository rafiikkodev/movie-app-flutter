import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> images;
  final double borderRadius;
  final int initialPage;
  final PageController _pageController;

  ImageCarousel({
    super.key,
    required this.images,
    this.borderRadius = 16,
    this.initialPage = 0,
  }) : _pageController = PageController(
         viewportFraction: 0.85,
         initialPage: initialPage,
       );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 6,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: ExtendedImage.asset(images[index], fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: images.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 8,
            activeDotColor: darkBlueAccent,
            dotColor: darkBlueAccent.withAlpha(30),
          ),
        ),
      ],
    );
  }
}

// Usage
// ImageCarousel(
//             images: [
//               'assets/images/carousel 2.png',
//               'assets/images/carousel 3.png',
//               'assets/images/carousel 4.png',
//             ],
//           ),
