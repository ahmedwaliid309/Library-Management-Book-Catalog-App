import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raffi/core/theme/app_colors.dart';
import 'package:raffi/core/theme/app_theme.dart';
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

  /// أغلفة الكتب زي ما الهوم بيعرضها (مؤقت لحد ما المسارات تتوحد).
  static const _homeCovers = {
    '1': 'assets/images/Frame 22.png',
    '4': 'assets/images/black.png',
    '2': 'assets/images/satel7osn.png',
  };

  Book _bookWithValidCover(Book book) {
    final cover = _homeCovers[book.id];
    if (cover == null) return book;

    return Book(
      id: book.id,
      title: book.title,
      author: book.author,
      coverAsset: cover,
      description: book.description,
      rating: book.rating,
      pages: book.pages,
      category: book.category,
    );
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
                    ? _FavoriteBookCard(
                  book: books[i],
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

/// كارت الكتاب الخاص بشاشة المفضلة (القلب أحمر).
class _FavoriteBookCard extends StatelessWidget {
  const _FavoriteBookCard({
    required this.book,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Book book;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: _cover(),
                ),
                PositionedDirectional(
                  top: 8.h,
                  start: 8.w,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 16.sp,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // رابط إنترنت أو asset أو مربع بديل لو مفيش غلاف
  Widget _cover() {
    final placeholder = Container(
      color: AppColors.chip,
      child: Icon(
        Icons.menu_book,
        color: AppColors.textSecondary,
        size: 32.sp,
      ),
    );

    final cover = book.coverAsset;
    if (cover.isEmpty) return placeholder;

    if (cover.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: cover,
        fit: BoxFit.cover,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      );
    }

    return Image.asset(
      cover,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
