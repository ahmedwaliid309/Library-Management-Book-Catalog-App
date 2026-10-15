import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

// المسؤول: سارة
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'عن التطبيق', owner: 'سارة');
  }
}
