import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/pages/onboarding_page.dart';
import 'package:template_project_flutter/app/pages/home_page.dart';
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
          icon: 'assets/icons-white/heart.svg',
          selectedIcon: 'assets/icons-blue-accent/heart.svg',
          label: 'Favorites',
        ),
        NavItem(
          icon: 'assets/icons-white/profile 1.svg',
          selectedIcon: 'assets/icons-blue-accent/profile 2.svg',
          label: 'Profile',
        ),
      ],
      pages: const [HomePage(), SearchPage(), FavoritesPage(), ProfilePage()],
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(
        child: Text(
          'Search Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: const Center(
        child: Text(
          'Favorites Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
