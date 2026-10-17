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
  late Future<List<Book>> _booksFuture;

  OutlineInputBorder get _noBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      );

  @override
  void initState() {
    super.initState();
    // الطلب بيبدأ مرة واحدة هنا
    _booksFuture = _load();
  }

  Future<List<Book>> _load() {
    final repo = context.read<BookRepository>();
    // مؤقتاً: كلمة بحث لكل قسم، لحد ما نحدد المنطق النهائي
    final query =
        widget.section == BookSection.recent ? 'روايات' : 'الأمير الصغير';
    return repo.search(query);
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
                      onTap: () {},
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

              // عنوان القسم وزر العودة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.section.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
                      fontFamily: AppTheme.fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
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

              SizedBox(height: 24.h),

              // شبكة الكتب (تحميل / لا نتائج / نتائج)
              Expanded(
                child: FutureBuilder<List<Book>>(
                  future: _booksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final books = snapshot.data ?? [];
                    if (books.isEmpty) {
                      return Center(
                        child: Text(
                          'لا توجد نتائج',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16.sp,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
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
                          onTap: () =>
                              context.push(AppRoutes.bookPath(book.id)),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}