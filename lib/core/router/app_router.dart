import 'package:go_router/go_router.dart';
import 'package:raffi/data/book_section.dart';

import '../../features/about/about_screen.dart';
import '../../features/book_details/book_details_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/see_all_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../widgets/main_shell.dart';

/// أسماء المسارات في مكان واحد. استخدمها بدل كتابة النص يدوي:
///   context.go(AppRoutes.home);
///   context.push(AppRoutes.bookPath('12'));
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const library = '/library';
  static const favorites = '/favorites';
  static const about = '/about';
  static const search = '/home/search';
  static const seeAll = '/see-all';
  static const bookDetails = '/book/:id';

  static String bookPath(String id) => '/book/$id';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // // شاشات برا الـ Bottom Nav
      // GoRoute(
      //   path: AppRoutes.search,
      //   builder: (context, state) => const SearchScreen(),
      // ),
      GoRoute(
        path: AppRoutes.seeAll,
        builder: (context, state) => const SeeAllScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookDetails,
        builder: (context, state) =>
            BookDetailsScreen(bookId: state.pathParameters['id'] ?? ''),
      ),

      // الشاشات الأربعة اللي جوه الـ Bottom Nav
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => SearchScreen(
                      section:
                          state.extra as BookSection? ?? BookSection.recent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.about,
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
