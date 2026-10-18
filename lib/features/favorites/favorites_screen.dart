import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/router/app_router.dart';
import '../../data/mock_books.dart'; // مؤقت للتجربة
import 'favorites_provider.dart';
import 'widgets/favorites_count_card.dart';
import 'widgets/favorites_empty_state.dart';
import 'widgets/favorites_header.dart';
import 'widgets/favorites_shelf.dart';

// المسؤول: السيد (حالة فاضية + حالة فيها كتب)
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final books = favorites.items;

    return Scaffold(
      // الـ Bottom Nav موجود في MainShell، فمش بنكرره هنا.
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // TODO(filter): زر الفلتر لسه من غير وظيفة.
            const FavoritesHeader(),
            FavoritesCountCard(count: books.length),
            // مؤقت للتجربة: يتشال قبل الكوميت
            TextButton(
              onPressed: () => context
                  .read<FavoritesProvider>()
                  .toggle(MockBooks.all[0]),
              child: const Text('تجربة: أضف / احذف كتاب'),
            ),
            Expanded(
              child: !favorites.isLoaded
              // تحميل: أثناء قراءة المفضلة من الجهاز
                  ? const Center(child: CircularProgressIndicator())
                  : books.isEmpty
                  ? FavoritesEmptyState(
                onDiscover: () => context.go(AppRoutes.home),
              )
                  : FavoritesShelf(
                books: books,
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