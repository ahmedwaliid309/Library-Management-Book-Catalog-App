import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// كتاب في المفضلة (بيانات تجريبية لحد ما اللوجيك يتضاف).
class FavoriteBook {
  const FavoriteBook({
    required this.id,
    required this.title,
    required this.author,
    this.coverColor = AppColors.primary,
    this.coverTextColor = AppColors.onPrimary,
    this.coverAsset,
  });

  /// بيتبعت لـ AppRoutes.bookPath(id) لما المستخدم يضغط على الكتاب.
  final String id;
  final String title;
  final String author;

  /// الغلاف المؤقت (لون + عنوان) لحد ما صور الأغلفة تتضاف.
  final Color coverColor;
  final Color coverTextColor;

  /// مسار صورة الغلاف، مثال: 'assets/covers/little_prince.jpg'.
  /// لازم تتسجل في pubspec.yaml. لو null أو مش موجودة بيظهر الغلاف الملوّن.
  final String? coverAsset;
}

/// بيانات تجريبية ثابتة (مفيش API دلوقتي).
const List<FavoriteBook> sampleFavoriteBooks = [
  FavoriteBook(
    id: '1',
    title: 'ممتلئ بالفراغ',
    author: 'د. عماد عثمان',
    coverColor: AppColors.surface,
    coverTextColor: AppColors.error,
  ),
  FavoriteBook(
    id: '2',
    title: 'فاتتني صلاة',
    author: 'إسلام جمال',
    coverColor: AppColors.primary,
  ),
  FavoriteBook(
    id: '3',
    title: 'خان الخليلي',
    author: 'نجيب محفوظ',
    coverColor: AppColors.banner,
  ),
  FavoriteBook(
    id: '4',
    title: 'الأيام',
    author: 'طه حسين',
    coverColor: AppColors.banner,
  ),
];
