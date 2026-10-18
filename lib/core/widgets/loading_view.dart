import 'package:raffi/core/theme/app_colors.dart';
import 'package:raffi/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String message;
  final IconData icon;

  const LoadingView({
    super.key,
    this.message = 'جاري تحميل البيانات...',
    this.icon = Icons.menu_book_rounded,
  });

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Icon(
          icon,
          size: 64,
          color: AppColors.primary
      ),

          const SizedBox(height: 24),

          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
