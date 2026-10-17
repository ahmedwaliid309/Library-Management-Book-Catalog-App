import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import 'data/favorite_book.dart';
import 'widgets/favorites_count_card.dart';
import 'widgets/favorites_empty_state.dart';
import 'widgets/favorites_header.dart';
import 'widgets/favorites_shelf.dart';

// المسؤول: السيد (حالة فاضية + حالة فيها كتب)
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // بيانات تجريبية
  List<FavoriteBook> _books = sampleFavoriteBooks;

  // للمراجعة بس: زر الفلتر
  // TODO(logic): يتشال ويتبدل بفلتر حقيقي.
  void _toggleDemoState() {
    setState(() {
      _books = _books.isEmpty ? sampleFavoriteBooks : const [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            FavoritesHeader(onFilterTap: _toggleDemoState),
            FavoritesCountCard(count: _books.length),
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