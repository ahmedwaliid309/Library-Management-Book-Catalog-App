import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:raffi/providers/library_provider.dart';
import 'package:raffi/providers/favorites_provider.dart';
import 'package:raffi/providers/history_provider.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/error_view.dart';
import '../../data/book_repository.dart';
import '../../data/models/book.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key, required this.bookId});

  final String bookId;

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isAddingBook = false;
  bool isLoading = true;
  bool isDescriptionExpanded = false;

  int selectedBookStatus = -1;

  Book? book;

  ImageProvider getCoverImage(Book book) {
    if (book.coverAsset.startsWith('https://') ||
        book.coverAsset.startsWith('http://')) {
      return NetworkImage(book.coverAsset);
    }

    if (book.coverAsset.isNotEmpty) {
      return AssetImage(book.coverAsset);
    }

    return const AssetImage('assets/images/الامير الصغير.png');
  }

  String formatDescription(String description) {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('quot&', '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final result = await BookRepository().details(widget.bookId);

      // تسجيل الكتاب في "آخر ما تصفحت" (HistoryProvider).
      // تعذر التسجيل لا يمنع عرض تفاصيل الكتاب.
      if (result != null && mounted) {
        try {
          await context.read<HistoryProvider>().recordViewedBook(result);
        } catch (_) {
          // تجاهل خطأ سجل التصفح.
        }
      }

      if (!mounted) return;

      setState(() {
        book = result;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        book = null;
        isLoading = false;
      });
    }
  }

  Future<void> _addBookToLibrary() async {
    if (book == null || isAddingBook) return;

    if (selectedBookStatus == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختاري الرف المناسب للكتاب أولاً')),
      );
      return;
    }

    final status = switch (selectedBookStatus) {
      0 => ReadingStatus.wantToRead,
      1 => ReadingStatus.currentlyReading,
      2 => ReadingStatus.completed,
      _ => ReadingStatus.wantToRead,
    };

    setState(() {
      isAddingBook = true;
    });

    try {
      final added = await context.read<LibraryProvider>().addBook(
        book!,
        status: status,
      );

      if (!mounted) return;

      if (!added) {
        setState(() {
          isAddingBook = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الكتاب موجود بالفعل في مكتبتك')),
        );
        return;
      }

      context.go(AppRoutes.library);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isAddingBook = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذرت إضافة الكتاب، حاولي مرة أخرى')),
      );
    }
  }

  Future<void> _toggleFavorite(Book currentBook) async {
    try {
      await context.read<FavoritesProvider>().toggle(currentBook);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تحديث المفضلة، حاولي مرة أخرى')),
      );
    }
  }

  Widget _buildShelfOption({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = selectedBookStatus == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedBookStatus = index;
          });
        },
        child: Container(
          height: 64.h,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFF4E2D4)
                : const Color(0xFFF6EFE1),
            border: isSelected
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.53))
                : null,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: 10.sp,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookInformation(Book currentBook) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          width: 0.54,
          color: AppColors.textPrimary.withValues(alpha: 0.1),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: _buildInfoItem(
                title: 'التصنيف',
                value: currentBook.category.isNotEmpty
                    ? currentBook.category
                          .split(RegExp(r'\s*&\s*|\s*,\s*'))
                          .where((category) => category.trim().isNotEmpty)
                          .join('\n')
                    : 'غير متاح',
              ),
            ),
            _buildDivider(),
            Expanded(
              child: _buildInfoItem(
                title: 'سنة النشر',
                value: currentBook.publishedDate.length >= 4
                    ? currentBook.publishedDate.substring(0, 4)
                    : 'غير متاح',
              ),
            ),
            _buildDivider(),
            Expanded(
              child: _buildInfoItem(
                title: 'الصفحات',
                value: currentBook.pages > 0
                    ? '${currentBook.pages}'
                    : 'غير متاح',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({required String title, required String value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.sp,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1.w,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: const Color(0x332B1D15),
    );
  }

  Widget _buildDescription(Book currentBook) {
    final description = formatDescription(currentBook.description);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'عن الكتاب',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20.sp,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: double.infinity,
          child: Text(
            description.isNotEmpty ? description : 'لا يتوفر وصف لهذا الكتاب.',
            maxLines: isDescriptionExpanded ? null : 5,
            overflow: isDescriptionExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            softWrap: true,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
        if (description.length > 250)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isDescriptionExpanded = !isDescriptionExpanded;
                });
              },
              child: Text(
                isDescriptionExpanded ? 'اقرأ أقل' : 'اقرأ المزيد',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLibrarySection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أضف إلى مكتبتي',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'اختاري الرف المناسب للكتاب',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/images/books.svg',
                width: 24.w,
                height: 24.h,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildShelfOption(
                index: 0,
                title: 'أريد قراءته',
                icon: Icons.bookmark_border,
              ),
              _buildShelfOption(
                index: 1,
                title: 'أقرأ حالياً',
                icon: Icons.menu_book_outlined,
              ),
              _buildShelfOption(
                index: 2,
                title: 'مكتمل',
                icon: Icons.check_rounded,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isAddingBook ? null : _addBookToLibrary,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isAddingBook ? 'جاري الإضافة...' : 'أضف إلى مكتبتي'),
                  SizedBox(width: 10.w),
                  if (isAddingBook)
                    SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(Icons.add_rounded, size: 24.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: LoadingView(
          message: 'جاري تحميل تفاصيل الكتاب...',
          icon: Icons.menu_book,
        ),
      );
    }

    if (book == null) {
      return Scaffold(
        body: ErrorView(
          title: 'تعذر تحميل تفاصيل الكتاب',
          message: 'حاولي الاتصال بالإنترنت مرة أخرى',
          icon: Icons.menu_book_rounded,
          onRetry: _loadBook,
        ),
      );
    }

    final currentBook = book!;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(currentBook.id);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24.h, left: 24.w, right: 24.w),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 55.h,
                  child: Container(
                    width: 270.w,
                    height: 270.h,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFF4E2D4),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildHeaderButton(
                          icon: isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          onPressed: () => _toggleFavorite(currentBook),
                          iconColor: isFavorite
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        Text(
                          'تفاصيل الكتاب',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20.sp,
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _buildHeaderButton(
                          icon: Icons.arrow_forward_rounded,
                          onPressed: () => context.go(AppRoutes.home),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: 254.w,
                      child: Column(
                        children: [
                          Container(
                            transform: Matrix4.identity()..rotateZ(0.05),
                            width: 173.w,
                            height: 260.h,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: getCoverImage(currentBook),
                                fit: BoxFit.cover,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.r),
                                  topRight: Radius.circular(6.r),
                                  bottomLeft: Radius.circular(12.r),
                                  bottomRight: Radius.circular(6.r),
                                ),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: AppColors.textPrimary,
                                  blurRadius: 0,
                                  offset: const Offset(8, 0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: 215.w,
                            height: 10.h,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(0.5, 0),
                                end: const Alignment(0.5, 1),
                                colors: [
                                  const Color(0xFF74503B),
                                  AppColors.textPrimary,
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                          Container(
                            width: 164.w,
                            height: 6.h,
                            color: const Color(0x192B1D15),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            currentBook.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 32.sp,
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentBook.author,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16.sp,
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildBookInformation(currentBook),
                    SizedBox(height: 24.h),
                    _buildDescription(currentBook),
                    SizedBox(height: 28.h),
                    _buildLibrarySection(),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _toggleFavorite(currentBook),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          isFavorite ? 'إزالة من المفضلة' : 'أضف إلى المفضلة',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return Container(
      width: 46.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor ?? AppColors.textPrimary),
      ),
    );
  }
}
