import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raffi/core/theme/app_colors.dart';
import 'package:raffi/core/theme/app_theme.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.title,
    required this.author,
    this.coverAsset,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  final String title;
  final String author;
  final String? coverAsset; // مسار الغلاف في assets
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الغلاف بنسبة 2:3 والقلب فوقه
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: _cover(),
                ),
                // start = اليمين في RTL
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
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
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
            author,
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

  // لو الصورة مش موجودة يظهر مربع بديل بدل ما التطبيق يقع
  Widget _cover() {
    final placeholder = Container(
      color: AppColors.chip,
      child: Icon(Icons.menu_book, color: AppColors.textSecondary, size: 32.sp),
    );
    if (coverAsset == null) return placeholder;
    return Image.asset(
      coverAsset!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}