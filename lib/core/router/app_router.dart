import 'package:go_router/go_router.dart';

import '../../data/book_section.dart';
import '../../features/about/about_screen.dart';
import '../../features/book_details/book_details_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../widgets/main_shell.dart';

/// أسماء المسارات في مكان واحد. استخدمها بدل كتابة النص يدوي:
///   context.go(AppRoutes.home);
///   context.push(AppRoutes.bookPath('12'));
///   context.push(AppRoutes.search, extra: BookSection.recommended);
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';

  // التابات الأربعة
  static const home = '/home';
  static const library = '/library';
  static const favorites = '/favorites';
  static const about = '/about';

  // Search جوه تاب Home (عشان الـ Bottom Nav يفضل ظاهر)
  static const search = '/home/search';

  // "عرض الكل" بتفتح نفس شاشة Search بقسم مختلف (BookSection)
  static const seeAll = search;

  // تفاصيل الكتاب
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

      // تفاصيل الكتاب (برا الـ Bottom Nav)
      GoRoute(
        path: AppRoutes.bookDetails,
        builder: (context, state) =>
            BookDetailsScreen(bookId: state.pathParameters['id'] ?? ''),
      ),

      // الشاشات الأربعة اللي جوه الـ Bottom Nav
      // مهم: ترتيب الـ Branches لازم يطابق ترتيب _items في main_shell.dart
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          // 0: الرئيسية (ومعاها Search)
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const home_screen(),
              routes: [
                GoRoute(
                  path: 'search', // نسبي: /home/search
                  builder: (context, state) {
                    final extra = state.extra;
                    return SearchScreen(
                      section:
                          extra is BookSection ? extra : BookSection.recent,
                    );
                  },
                ),
              ],
            ),
          ]),

          // 1: مكتبتي
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.library,
              builder: (context, state) => const LibraryScreen(),
            ),
          ]),

          // 2: المفضلة
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, state) => const FavoritesScreen(),
            ),
          ]),

          // 3: عن التطبيق
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.about,
              builder: (context, state) => const AboutScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
}