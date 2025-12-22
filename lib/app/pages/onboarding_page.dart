import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/widgets/buttons.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();

  List<String> titles = [
    "The biggest international and local film streaming",
    "Offers ad-free viewing of high quality",
    "Our service brings together your favorite series",
  ];

  List<String> subtitles = [
    "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient. ",
    "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient. ",
    "Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient. ",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              items: [
                Image.asset("assets/images/img_onboarding1.webp", height: 331),
                Image.asset("assets/images/img_onboarding2.webp", height: 331),
                Image.asset("assets/images/img_onboarding3.webp", height: 331),
              ],
              options: CarouselOptions(
                height: 331,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              carouselController: carouselController,
            ),
            const SizedBox(height: 80),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              decoration: BoxDecoration(
                color: blackColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    titles[currentIndex],
                    style: whiteTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: semiBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
                  Text(
                    subtitles[currentIndex],
                    style: greyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: currentIndex == 2 ? 38 : 50),
                  currentIndex == 2
                      ? Column(
                          children: [
                            CustomButton.primary(
                              title: "Get Started",
                              width: double.infinity,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/sign-up",
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomButton.outlined(
                              title: "Sign In",
                              width: double.infinity,
                              onPressed: () {
                                Navigator.pushNamed(context, "/sign-in");
                              },
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            // Indicator dots
                            Container(
                              width: 12,
                              height: 12,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentIndex == 0
                                    ? darkBlueAccent
                                    : darkBlueAccent.withAlpha(30),
                              ),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentIndex == 1
                                    ? darkBlueAccent
                                    : darkBlueAccent.withAlpha(30),
                              ),
                            ),
                            Container(
                              width: 12,
                              height: 12,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentIndex == 2
                                    ? darkBlueAccent
                                    : darkBlueAccent.withAlpha(30),
                              ),
                            ),
                            const Spacer(),
                            // Next button with fixed width
                            CustomButton.primary(
                              title: "Continue",
                              width: 120,
                              onPressed: () {
                                carouselController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
