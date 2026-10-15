import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

// المسؤول: السيد (حالة فاضية + حالة فيها كتب)
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'المفضلة', owner: 'السيد');
  }
}
