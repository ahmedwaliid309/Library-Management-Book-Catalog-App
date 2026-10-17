import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
void main() {
  runApp(const MyApp());
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
