import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/home_carousel_models.dart';

class HomeCarousel extends StatelessWidget {
  final List<HomeCarouselItem> items;
  final double borderRadius;
  final int initialPage;
  final PageController _pageController;

  HomeCarousel({
    super.key,
    required this.items,
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
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: ExtendedImage.asset(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [blackColor.withAlpha(45), blackColor],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: whiteTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            style: greyTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: medium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: items.length,
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
// HomeCarousel(
//             items: [
//               CarouselItem(
//                 imageUrl: 'assets/images/carousel 2.png',
//                 title: 'Title 1',
//                 subtitle: 'Subtitle 1',
//               ),
//               CarouselItem(
//                 imageUrl: 'assets/images/carousel 3.png',
//                 title: 'Title 2',
//                 subtitle: 'Subtitle 2',
//               ),
//               CarouselItem(
//                 imageUrl: 'assets/images/carousel 4.png',
//                 title: 'Title 3',
//                 subtitle: 'Subtitle 3',
//               ),
//             ],
//           ),
