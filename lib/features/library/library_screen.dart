import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

// المسؤول: أحمد عطا (مكتبتي + Sheet إضافة كتاب)
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'مكتبتي', owner: 'أحمد عطا');
  }
}
