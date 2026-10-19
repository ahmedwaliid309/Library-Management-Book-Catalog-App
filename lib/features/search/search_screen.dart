import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:raffi/core/router/app_router.dart';
import 'package:raffi/core/theme/app_colors.dart';
import 'package:raffi/core/theme/app_theme.dart';
import 'package:raffi/core/widgets/book_card.dart';
import 'package:raffi/data/book_repository.dart';
import 'package:raffi/data/book_section.dart';
import 'package:raffi/data/models/book.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.section = BookSection.recent});

  final BookSection section;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _debounceDuration = Duration(milliseconds: 500);

  final _controller = TextEditingController();
  Timer? _debounce;

  /// الكلمة اللي بتتبحث دلوقتي. فاضية = كتب القسم الافتراضية.
  String _query = '';
  late Future<List<Book>> _booksFuture;

  OutlineInputBorder get _noBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      );

  @override
  void initState() {
    super.initState();
    _booksFuture = _load(); // الطلب الأول مرة واحدة
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // TODO: "آخر ما تصفحت" تيجي من HistoryProvider (سارة) لما يجهز
  String get _defaultQuery =>
      widget.section == BookSection.recent ? 'روايات' : 'أدب';

  Future<List<Book>> _load() {
    final repo = context.read<BookRepository>();
    return repo.search(_query.isEmpty ? _defaultQuery : _query);
  }

  // مع كل حرف، بس الطلب مش بيتبعت غير بعد ما المستخدم يوقف كتابة نص ثانية
  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      if (mounted) _runSearch(value);
    });
    setState(() {}); // عشان زر المسح يظهر ويختفي
  }

  // زر البحث على الكيبورد: يبحث فوراً
  void _onSubmitted(String value) {
    _debounce?.cancel();
    _runSearch(value);
  }

  void _runSearch(String value) {
    final q = value.trim();
    if (q == _query) return; // نفس الكلمة، مفيش داعي لطلب جديد
    setState(() {
      _query = q;
      _booksFuture = _load();
    });
  }

  void _clear() {
    _controller.clear();
    _debounce?.cancel();
    _runSearch('');
    setState(() {});
  }

  void _retry() => setState(() => _booksFuture = _load());

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أهلا بيك فى رفّي 🤎.',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'جاهز تكتشف كتابك الجاي؟',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24.h),

              // حقل البحث وزر الفلتر
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: _onChanged,
                      onSubmitted: _onSubmitted,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.surface,
                        hintText: 'ابحث عن كتاب أو مؤلف....',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontFamily: AppTheme.fontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                          size: 24.sp,
                        ),
                        suffixIcon: _controller.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.textSecondary,
                                  size: 20.sp,
                                ),
                                onPressed: _clear,
                              ),
                        border: _noBorder,
                        enabledBorder: _noBorder,
                        focusedBorder: _noBorder,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () {
                        // TODO: فتح Bottom Sheet الفلتر (شغل معاذ)
                      },
                      child: SizedBox(
                        width: 52.w,
                        height: 52.h,
                        child: Icon(
                          Icons.filter_list,
                          color: AppColors.banner,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // العنوان وزر العودة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _query.isEmpty ? widget.section.title : 'نتائج البحث',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
                      fontFamily: AppTheme.fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: _goBack,
                    child: Text(
                      'العودة',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                        fontFamily: AppTheme.fontFamily,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Expanded(child: _buildResults()),
            ],
          ),
        ),
      ),
    );
  }

  // تحميل / خطأ / لا نتايج / النتايج
  Widget _buildResults() {
    return FutureBuilder<List<Book>>(
      future: _booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _StatusView(
            loading: true,
            title: _query.isEmpty
                ? 'جاري تحميل الكتب...'
                : 'جاري البحث عن "$_query"...',
          );
        }

        if (snapshot.hasError) {
          return _StatusView(
            icon: Icons.wifi_off_rounded,
            title: 'تعذر تحميل البيانات',
            message: 'تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
            onRetry: _retry,
          );
        }

        final books = snapshot.data ?? [];
        if (books.isEmpty) {
          return _StatusView(
            icon: Icons.menu_book_outlined,
            title: _query.isEmpty
                ? 'لا توجد كتب حالياً'
                : 'لا توجد نتائج لـ "$_query"',
          );
        }

        return GridView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: books.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.55,
          ),
          itemBuilder: (context, index) {
            final book = books[index];
            return BookCard(
              title: book.title,
              author: book.author,
              coverAsset: book.coverAsset,
              onTap: () => context.push(AppRoutes.bookPath(book.id)),
            );
          },
        );
      },
    );
  }
}

/// شاشة حالة موحدة (تحميل / خطأ / فاضية) لحد ما نستخدم ويدجتس إيمان المشتركة.
class _StatusView extends StatelessWidget {
  const _StatusView({
    required this.title,
    this.message,
    this.icon,
    this.loading = false,
    this.onRetry,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final bool loading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              const CircularProgressIndicator(color: AppColors.primary)
            else if (icon != null)
              Icon(icon, size: 56.sp, color: AppColors.textSecondary),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (message != null) ...[
              SizedBox(height: 8.h),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (onRetry != null) ...[
              SizedBox(height: 20.h),
              SizedBox(
                width: 200.w,
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('إعادة المحاولة'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}