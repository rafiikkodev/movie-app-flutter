import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class HomeCarouselItem {
  final String imageUrl;
  final String title;
  final String subtitle;

  const HomeCarouselItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
}

class HomeCarousel extends StatefulWidget {
  final List<HomeCarouselItem> items;
  final int initialPage;

  const HomeCarousel({super.key, required this.items, this.initialPage = 0});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.items.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Background image
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: softColor,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: darkBlueAccent,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: softColor,
                              child: Icon(
                                Icons.movie,
                                color: greyColor,
                                size: 80,
                              ),
                            ),
                          ),
                        ),
                        // Gradient overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: whiteTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: semiBold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.subtitle,
                                style: greyTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 154,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: widget.initialPage,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items.asMap().entries.map((entry) {
            return Container(
              width: currentIndex == entry.key ? 20 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: currentIndex == entry.key
                    ? darkBlueAccent
                    : greyColor.withOpacity(0.3),
              ),
            );
          }).toList(),
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
