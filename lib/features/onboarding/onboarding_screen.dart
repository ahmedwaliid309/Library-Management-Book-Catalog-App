
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // هنا جهزنا بيانات كل صفحة من صورة وعنوان ووصف،
  // علشان نعرض الصفحتين بنفس الكود بدل ما نكرر تصميم كل صفحة.
  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/raffi2.jpg',
      'title': 'رفوفك بطريقتك',
      'description':
      'نظم مكتبتك واجمع كتبك المفضلة في مساحة واحدة. '
          'واستمتع بالوصول إليها في أي وقت.',
    },
    {
      'image': 'assets/images/raffi3.jpg',
      'title': 'اكتشف حكايتك القادمة',
      'description':
      'استكشف كتبا جديدة واكتشف قصصا وعوالم '
          'تأخذك إلى أماكن مختلفة.',
    },
  ];

  @override
  void dispose() {
    // هنا بنحرر الـ PageController لما الشاشة تتقفل.
    _pageController.dispose();
    super.dispose();
  }

  // هنا بننقل المستخدم للصفحة التالية، ولو وصل لآخر صفحة
  // بنوجّهه للصفحة الرئيسية.
  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(
                height: 52.h,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => context.go(AppRoutes.home),
                        child: Text(
                          'تخطي',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/raffi.png',
                        width: 75.w,
                        height: 42.h,
                        fit: BoxFit.contain,
                        // هنا بنعرض اللوجو، ولو حصل خطأ بنعرض نص بديل.
                        errorBuilder: (context, error, stackTrace) => Text(
                          'رفّي',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  // هنا بنحدّث رقم الصفحة الحالية علشان المؤشرات
                  // ونص الزرار يتغيروا مع انتقال المستخدم.
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];

                    return Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Image.asset(
                              page['image']!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              // هنا بنعرض الرسمة، ولو حصل خطأ بنعرض أيقونة بديلة.
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.auto_stories_rounded,
                                size: 150.r,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          page['description']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 15.sp,
                            height: 1.7,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    );
                  },
                ),
              ),

              // هنا بنعرض مؤشر لكل صفحة، وبنميّز الصفحة الحالية
              // بلون وعرض مختلفين.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: _currentPage == index ? 22.w : 8.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  // هنا نص الزرار والأيقونة بيتغيروا حسب الصفحة الحالية.
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == _pages.length - 1
                            ? 'ابدأ الآن'
                            : 'التالي',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        _currentPage == _pages.length - 1
                            ? Icons.arrow_back_rounded
                            : Icons.arrow_forward_rounded,
                        size: 20.r,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
