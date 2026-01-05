import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/data/providers/favorite_provider.dart';
import 'package:template_project_flutter/app/pages/onboarding_page.dart';
import 'package:template_project_flutter/app/pages/home_page.dart';
import 'package:template_project_flutter/app/pages/profile_page.dart';
import 'package:template_project_flutter/app/pages/search_by_actor_page.dart';
import 'package:template_project_flutter/app/pages/search_page.dart';
import 'package:template_project_flutter/app/pages/search_result_page.dart';
import 'package:template_project_flutter/app/pages/signin_page.dart';
import 'package:template_project_flutter/app/pages/signup_page.dart';
import 'package:template_project_flutter/app/pages/trailer_page.dart';
import 'package:template_project_flutter/app/pages/wishlist_page.dart';
import 'package:template_project_flutter/app/data/services/auth_state_listener.dart';
import 'package:template_project_flutter/widgets/navbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoriteProvider(),
      child: MaterialApp(
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
          "/": (context) => AuthStateListener(
            builder: (isAuthenticated) {
              if (isAuthenticated) {
                // Initialize favorites when user is authenticated
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<FavoriteProvider>().initialize();
                });
                return const MainNavigation();
              } else {
                // Reset favorites when user logs out
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<FavoriteProvider>().reset();
                });
                return const OnboardingPage();
              }
            },
          ),
          "/sign-in": (context) => const SigninPage(),
          "/sign-up": (context) => const SignupPage(),
          "/home": (context) => const MainNavigation(),
          "/search": (context) => const SearchPage(),
          "/search_result": (context) => const SearchResultPage(),
          "/search_by_actor": (context) => const SearchByActorPage(),
          "/download": (context) => const WishlistPage(),
          "/wishlist": (context) => const WishlistPage(showBackButton: true),
          "/profile": (context) => const ProfilePage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/trailer') {
            final movie = settings.arguments as MovieModel;
            return MaterialPageRoute(
              builder: (context) => TrailerPage(movie: movie),
            );
          }
          return null;
        },
      ),
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
          label: 'Wishlist',
        ),
        NavItem(
          icon: 'assets/icons-white/profile 1.svg',
          selectedIcon: 'assets/icons-blue-accent/profile 2.svg',
          label: 'Profile',
        ),
      ],
      pages: [HomePage(), SearchPage(), WishlistPage(), ProfilePage()],
    );
  }
}
