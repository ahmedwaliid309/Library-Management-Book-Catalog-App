import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raffi/core/theme/app_colors.dart';
import 'package:raffi/core/theme/app_theme.dart';
import 'package:raffi/core/widgets/book_card.dart';
import 'package:go_router/go_router.dart';
import 'package:raffi/core/router/app_router.dart';
import 'package:raffi/data/book_section.dart';
import 'package:raffi/data/mock_books.dart';

// المسؤول: أحمد وليد (حالة قبل البحث + حالة النتائج)
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, this.section = BookSection.recent});

  // حدود بدون خط بزوايا مدورة
  OutlineInputBorder get _noBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: BorderSide.none,
  );

  final BookSection section;

  @override
  Widget build(BuildContext context) {
    final books = MockBooks.forSection(section);
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
                    shadowColor: AppColors.banner,
                    elevation: 0.1,
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

              // عنوان آخر ما تصفحت
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    section.title,
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

              // شبكة الكتب
              Expanded(
                child: GridView.builder(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
