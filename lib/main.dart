import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raffi/providers/favorites_provider.dart';
import 'package:raffi/providers/history_provider.dart';
import 'package:raffi/providers/library_provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/book_repository.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<BookRepository>(create: (_) => BookRepository()),
        // مؤقت للتجربة: الـ lead هو اللي هيضيفه رسمي
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()..loadHistory()),
        ChangeNotifierProvider(create: (_) => LibraryProvider()..loadLibrary()),
      ],
      child: const RaffiApp(),
    ),
  );
}

class RaffiApp extends StatelessWidget {
  const RaffiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'رفّي',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}