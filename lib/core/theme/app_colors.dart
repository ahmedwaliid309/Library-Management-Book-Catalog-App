import 'package:flutter/material.dart';

/// كل ألوان التطبيق هنا. ممنوع كتابة لون يدوي داخل الشاشات.
/// الألوان اللي عليها TODO مشتقة تقريبياً من الألوان الأساسية،
/// وتتراجع من Figma (Dev Mode) وتتعدل هنا في مكان واحد.
class AppColors {
  AppColors._();

  // ===== الألوان الأساسية (من التصميم) =====
  static const Color primary = Color(0xFFBF6428); // البرتقالي (لوجو + الأزرار)
  static const Color background = Color(0xFFFCF8EE); // الكريمي (خلفية كل الشاشات)
  static const Color textPrimary = Color(0xFF2B1D15); // البني الغامق

  // ===== مشتقة، TODO: تأكيد من Figma =====
  static const Color primaryDark = Color(0xFFA2501D); // الضغط على الزر
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF7A675B); // نصوص ثانوية
  static const Color surface = Color(0xFFFFFFFF); // كروت وحقول
  static const Color chip = Color(0xFFF3E9D8); // خلفية الـ Chips
  static const Color border = Color(0xFFE8DDC9); // الحدود الخفيفة
  static const Color shelf = Color(0xFF6B4A33); // خط الرف الخشب
  static const Color banner = Color(0xFF2B1D15); // بانر Home الداكن
  static const Color error = Color(0xFFB3261E);
}
