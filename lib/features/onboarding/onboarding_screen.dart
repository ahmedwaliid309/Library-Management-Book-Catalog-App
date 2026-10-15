import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/widgets/placeholder_screen.dart';

// المسؤول: سارة (خطوتين في PageView)
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Onboarding',
      owner: 'سارة',
      children: [
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('ابدأ الآن'),
        ),
      ],
    );
  }
}
