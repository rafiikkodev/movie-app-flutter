import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/pages/download_page.dart';
import 'package:template_project_flutter/app/pages/movie_detail_page.dart';
import 'package:template_project_flutter/app/pages/onboarding_page.dart';
import 'package:template_project_flutter/app/pages/home_page.dart';
import 'package:template_project_flutter/app/pages/profile_page.dart';
import 'package:template_project_flutter/app/pages/search_by_actor_page.dart';
import 'package:template_project_flutter/app/pages/search_page.dart';
import 'package:template_project_flutter/app/pages/search_result_page.dart';
import 'package:template_project_flutter/app/pages/wishlist_page.dart';
import 'package:template_project_flutter/widgets/navbar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: darkBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: darkBackgroundColor,
          surfaceTintColor: darkBackgroundColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: blackColor),
          titleTextStyle: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      routes: {
        "/": (context) => const OnboardingPage(),
        "/home": (context) => const MainNavigation(),
        "/search": (context) => const SearchPage(),
        "/search_result": (context) => const SearchResultPage(),
        "/search_by_actor": (context) => const SearchByActorPage(),
        "/movie_detail": (context) => const MovieDetailPage(),
        "/download": (context) => const DownloadPage(),
        "/wishlist": (context) => const WishlistPage(),
        "/profile": (context) => const ProfilePage(),
      },
    );
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomNavigationBar(
      items: const [
        NavItem(
          icon: 'assets/icons-white/home.svg',
          selectedIcon: 'assets/icons-blue-accent/home.svg',
          label: 'Home',
        ),
        NavItem(
          icon: 'assets/icons-white/search.svg',
          selectedIcon: 'assets/icons-blue-accent/search.svg',
          label: 'Search',
        ),
        NavItem(
          icon: 'assets/icons-white/download.svg',
          selectedIcon: 'assets/icons-blue-accent/download.svg',
          label: 'Download',
        ),
        NavItem(
          icon: 'assets/icons-white/profile 1.svg',
          selectedIcon: 'assets/icons-blue-accent/profile 2.svg',
          label: 'Profile',
        ),
      ],
      pages: const [HomePage(), SearchPage(), DownloadPage(), ProfilePage()],
    );
  }
}
