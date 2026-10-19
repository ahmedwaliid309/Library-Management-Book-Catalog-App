import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import 'shelf_board.dart';

/// حالة "مكتبته فارغة ".
class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key, required this.onDiscover});

  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 293.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _EmptyShelf(),
            SizedBox(height: 24.h),
            Text(
              'مكتبتك فارغة حاليًا',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'ضف كتبك المفضلة لتجدها هنا وتعود\nإليها في أي وقت.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
            // الزر من الـ Theme
            SizedBox(
              width: 160.w,
              height: 50.h,
              child: ElevatedButton(
                onPressed: onDiscover,
                child: const Text('اكتشف الكتب'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyShelf extends StatelessWidget {
  const _EmptyShelf();


  Widget _leg() => Container(
    width: 8.w,
    height: 37.h,
    decoration: BoxDecoration(
      color: AppColors.shelf,
      borderRadius: BorderRadius.vertical(top: Radius.circular(3.r)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 215.w,
      height: 53.h,
      child: Stack(
        children: [
          //  اللوح العمودي
          PositionedDirectional(start: 14.w, bottom: 16.h, child: _leg()),
          PositionedDirectional(end: 14.w, bottom: 16.h, child: _leg()),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ShelfBoard(stripInset: 25.5),
          ),
        ],
      ),
    );
  }
}