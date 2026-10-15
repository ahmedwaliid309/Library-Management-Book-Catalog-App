import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/widgets/placeholder_screen.dart';

// المسؤول: معاذ (الشاشة + بانر + فلتر Sheet + عرض الكل)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Home',
      owner: 'معاذ',
      children: [
        ElevatedButton(
          onPressed: () => context.push(AppRoutes.search),
          child: const Text('البحث'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => context.push(AppRoutes.seeAll),
          child: const Text('عرض الكل'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => context.push(AppRoutes.bookPath('1')),
          child: const Text('تفاصيل كتاب'),
        ),
      ],
    );
  }
}
