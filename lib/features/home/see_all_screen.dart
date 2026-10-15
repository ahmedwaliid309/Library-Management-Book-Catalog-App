import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

// المسؤول: معاذ (شبكة "آخر ما تصفحت")
class SeeAllScreen extends StatelessWidget {
  const SeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'عرض الكل', owner: 'معاذ');
  }
}
