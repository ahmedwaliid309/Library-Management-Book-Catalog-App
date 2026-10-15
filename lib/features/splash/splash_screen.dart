import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/widgets/placeholder_screen.dart';

// المسؤول: إيمان
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Splash',
      owner: 'إيمان',
      children: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.onboarding),
          child: const Text('اكتشف رفّي'),
        ),
      ],
    );
  }
}
