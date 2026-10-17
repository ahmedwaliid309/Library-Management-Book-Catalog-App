import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../data/favorite_book.dart';
import 'shelf_board.dart';

/// الكتب على رفوف، كل رف فيه 3 كتب.
class FavoritesShelf extends StatelessWidget {
  const FavoritesShelf({
    super.key,
    required this.books,
    required this.onBookTap,
  });

  final List<FavoriteBook> books;
  final ValueChanged<FavoriteBook> onBookTap;

  static const int perShelf = 3;

  @override
  Widget build(BuildContext context) {
    final rows = <List<FavoriteBook>>[];
    for (var i = 0; i < books.length; i += perShelf) {
      final end = i + perShelf > books.length ? books.length : i + perShelf;
      rows.add(books.sublist(i, end));
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
      itemCount: rows.length,
      separatorBuilder: (_, __) => SizedBox(height: 28.h),
      itemBuilder: (_, i) => _ShelfRow(books: rows[i], onBookTap: onBookTap),
    );
  }
}

class _ShelfRow extends StatelessWidget {
  const _ShelfRow({required this.books, required this.onBookTap});

  final List<FavoriteBook> books;
  final ValueChanged<FavoriteBook> onBookTap;

  Widget _slot(Widget? child) => Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: child ?? const SizedBox.shrink(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    const slots = FavoritesShelf.perShelf;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < slots; i++)
              _slot(
                i < books.length
                    ? _BookCover(
                  book: books[i],
                  onTap: () => onBookTap(books[i]),
                )
                    : null,
              ),
          ],
        ),
        const ShelfBoard(),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < slots; i++)
              _slot(i < books.length ? _BookCaption(book: books[i]) : null),
          ],
        ),
      ],
    );
  }
}

class _BookCaption extends StatelessWidget {
  const _BookCaption({required this.book});

  final FavoriteBook book;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          book.author,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.book, required this.onTap});

  final FavoriteBook book;
  final VoidCallback onTap;

  Widget _placeholder() => Container(
    color: book.coverColor,
    alignment: Alignment.center,
    padding: EdgeInsets.all(6.w),
    child: Text(
      book.title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
        color: book.coverTextColor,
      ),
    ),
  );

  Widget _cover() {
    final asset = book.coverAsset;
    if (asset == null) return _placeholder();
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8.r);

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 0.68,
        child: Stack(
          children: [
            // ظهر الكتاب
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withAlpha(51),
                      blurRadius: 6.r,
                      offset: Offset(2.w, 3.h),
                    ),
                  ],
                ),
              ),
            ),
            // الغلاف
            PositionedDirectional(
              top: 0,
              bottom: 0,
              start: 6.w,
              end: 0,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(borderRadius: radius),
                child: _cover(),
              ),
            ),
            // القلب
            PositionedDirectional(
              top: 4.h,
              start: 8.w,
              child: Container(
                width: 30.w,
                height: 30.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface.withAlpha(120),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: 14.sp,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}