import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'features/home/home_screen.dart';
void main() {
  runApp(const MyApp());
=======
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
>>>>>>> origin/develop
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _State();
}

class _State extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme:  ColorScheme.fromSeed(seedColor: Color(0xffFCF8EE)),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const home_screen()
    );
  }
}
