import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import 'data/favorite_book.dart';

import 'widgets/favorites_empty_state.dart';

import 'widgets/favorites_shelf.dart';

// المسؤول: السيد (حالة فاضية + حالة فيها كتب)
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // بيانات تجريبية. في مرحلة اللوجيك هتتبدل بالمفضلة الحقيقية.
  List<FavoriteBook> _books = sampleFavoriteBooks;

  // للمراجعة بس: زر الفلتر بيبدّل بين حالة الكتب والحالة الفاضية.
  // TODO(logic): يتشال ويتبدل بفلتر حقيقي.
  void _toggleDemoState() {
    setState(() {
      _books = _books.isEmpty ? sampleFavoriteBooks : const [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الـ Bottom Nav موجود في MainShell، فمش بنكرره هنا.
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: _books.isEmpty
                  ? FavoritesEmptyState(
                onDiscover: () => context.go(AppRoutes.home),
              )
                  : FavoritesShelf(
                books: _books,
                onBookTap: (book) =>
                    context.push(AppRoutes.bookPath(book.id)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}