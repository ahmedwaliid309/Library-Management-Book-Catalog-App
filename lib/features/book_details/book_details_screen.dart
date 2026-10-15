import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_screen.dart';

// المسؤول: إيمان
class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'تفاصيل الكتاب (#$bookId)',
      owner: 'إيمان',
    );
  }
}
