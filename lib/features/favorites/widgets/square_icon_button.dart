import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// زر أيقونة مربع أبيض (الفلتر + أيقونة الكارت).
class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor = AppColors.textPrimary,
    this.width = 40,
    this.height = 40,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0.5,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: SizedBox(
          width: width.w,
          height: height.h,
          child: Icon(icon, size: 20.sp, color: iconColor),
        ),
      ),
    );
  }
}