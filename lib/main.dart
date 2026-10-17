import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raffi/data/book_repository.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    Provider<BookRepository>(
      create: (_) => BookRepository(),
      child: const RaffiApp(),
    ),
  );
}

class RaffiApp extends StatelessWidget {
  const RaffiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // حجم الـ Frame في Figma. غيّره لو الفريمات عندكم بحجم مختلف.
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'رفّي',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          // التطبيق عربي RTL في كل الشاشات
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
