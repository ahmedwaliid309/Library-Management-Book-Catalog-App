import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    this.title = 'حدث خطأ',
    this.message = 'حصلت مشكلة أثناء تحميل البيانات.',
    this.icon = Icons.error_outline_rounded,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 64.w,
                  color: AppColors.primary,
                ),
                Positioned(
                  top: -4.h,
                  right: -6.w,
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCF8EE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 19.w,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20.sp,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 20.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('حاولي مرة تانية'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
