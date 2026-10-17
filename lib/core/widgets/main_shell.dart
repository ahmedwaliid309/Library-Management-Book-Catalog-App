import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:raffi/core/theme/app_colors.dart';
import 'package:raffi/core/theme/app_theme.dart';

/// الـ Bottom Navigation: كارت أبيض عايم فوق الخلفية.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // الترتيب هنا = ترتيب الـ Branches في app_router.dart
  static const _items = [
    _NavItemData(Icons.home_outlined, 'الرئيسية'),
    _NavItemData(Icons.collections_bookmark_outlined, 'مكتبتي'),
    _NavItemData(Icons.favorite_border, 'المفضلة'),
    _NavItemData(Icons.info_outline, 'عن التطبيق'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
          child: Material(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
              side: const BorderSide(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  for (var i = 0; i < _items.length; i++)
                    Expanded(
                      child: _NavItem(
                        data: _items[i],
                        selected: navigationShell.currentIndex == i,
                        onTap: () => navigationShell.goBranch(
                          i,
                          initialLocation: i == navigationShell.currentIndex,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData(this.icon, this.label);
  final IconData icon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // المحدد برتقالي، وغيره بني غامق
    final color = selected ? AppColors.primary : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, color: color, size: 28.sp),
          SizedBox(height: 6.h),
          Text(
            data.label,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}