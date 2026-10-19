import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import 'square_icon_button.dart';

/// كارت "مكتمل" + عدد الكتب (بيتغير حسب [count]).
class FavoritesCountCard extends StatelessWidget {
  const FavoritesCountCard({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          const SquareIconButton(
            icon: Icons.bookmark_border_rounded,
            iconColor: AppColors.primary,
          ),
          SizedBox(width: 10.w),
          Text(
            'مكتمل',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            width: 66.w,
            height: 26.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$count كتب',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}