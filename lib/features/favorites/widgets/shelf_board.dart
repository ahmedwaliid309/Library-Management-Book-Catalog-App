import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// لوح الرف

class ShelfBoard extends StatelessWidget {
  const ShelfBoard({super.key, this.stripInset = 24});

  /// المسافة بين طرف اللوح وطرف الشريط الفاتح (من كل جنب).
  final double stripInset;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Container(
          height: 10.h,
          decoration: BoxDecoration(
            color: AppColors.shelf,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(2.r),
              bottom: Radius.circular(5.r),
            ),
          ),
        ),
        // الشريط الفاتح تحت اللوح
        Container(
          height: 6.h,
          margin: EdgeInsets.symmetric(horizontal: stripInset.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(3.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withAlpha(40),
                blurRadius: 6.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
        ),
      ],
    );
  }
}