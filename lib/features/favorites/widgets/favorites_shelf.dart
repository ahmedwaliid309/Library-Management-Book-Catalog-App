import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raffi/core/widgets/book_card.dart';
import 'package:raffi/data/mock_books.dart';
import 'package:raffi/data/models/book.dart';

import 'shelf_board.dart';

/// الكتب المفضلة على رفوف، كل رف فيه 3 كتب.
class FavoritesShelf extends StatelessWidget {
  const FavoritesShelf({
    super.key,
    required this.books,
    required this.onBookTap,
    required this.onFavoriteTap,
  });

  final List<Book> books;
  final ValueChanged<Book> onBookTap;
  final ValueChanged<Book> onFavoriteTap;

  static const int perShelf = 3;

  Book _bookWithValidCover(Book book) {
    final mockBook = MockBooks.byId(book.id);

    if (book.coverAsset.isEmpty &&
        mockBook != null &&
        mockBook.coverAsset.isNotEmpty) {
      return Book(
        id: book.id,
        title: book.title,
        author: book.author,
        coverAsset: mockBook.coverAsset,
        description: book.description,
        rating: book.rating,
        pages: book.pages,
        category: book.category,
      );
    }

    return book;
  }

  @override
  Widget build(BuildContext context) {
    final rows = <List<Book>>[];

    for (var i = 0; i < books.length; i += perShelf) {
      final end =
      i + perShelf > books.length ? books.length : i + perShelf;
      rows.add(books.sublist(i, end));
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
      itemCount: rows.length,
      separatorBuilder: (_, __) => SizedBox(height: 28.h),
      itemBuilder: (context, i) => _ShelfRow(
        books: rows[i].map(_bookWithValidCover).toList(),
        onBookTap: onBookTap,
        onFavoriteTap: onFavoriteTap,
      ),
    );
  }
}

class _ShelfRow extends StatelessWidget {
  const _ShelfRow({
    required this.books,
    required this.onBookTap,
    required this.onFavoriteTap,
  });

  final List<Book> books;
  final ValueChanged<Book> onBookTap;
  final ValueChanged<Book> onFavoriteTap;

  Widget _slot(Widget? child) => Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: child ?? const SizedBox.shrink(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < FavoritesShelf.perShelf; i++)
              _slot(
                i < books.length
                    ? BookCard(
                  title: books[i].title,
                  author: books[i].author,
                  coverAsset: books[i].coverAsset,
                  isFavorite: true,
                  onTap: () => onBookTap(books[i]),
                  onFavoriteTap: () => onFavoriteTap(books[i]),
                )
                    : null,
              ),
          ],
        ),
        const ShelfBoard(),
      ],
    );
  }
}
