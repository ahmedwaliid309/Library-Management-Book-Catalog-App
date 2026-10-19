import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/router/app_router.dart';
import '../../providers/favorites_provider.dart';
import 'widgets/favorites_count_card.dart';
import 'widgets/favorites_empty_state.dart';
import 'widgets/favorites_header.dart';
import 'widgets/favorites_shelf.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final books = favorites.items;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const FavoritesHeader(),
            FavoritesCountCard(count: books.length),
            Expanded(
              child: !favorites.isLoaded
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : books.isEmpty
                  ? FavoritesEmptyState(
                onDiscover: () =>
                    context.go(AppRoutes.search),
              )
                  : FavoritesShelf(
                books: books,
                onBookTap: (book) => context.push(
                  AppRoutes.bookPath(book.id),
                ),
                onFavoriteTap: (book) {
                  context
                      .read<FavoritesProvider>()
                      .toggle(book);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}