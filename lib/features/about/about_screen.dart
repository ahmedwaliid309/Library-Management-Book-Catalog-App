
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // هنا جمعنا أسماء أعضاء فريق رفّي في قائمة واحدة.
  static const List<String> teamMembers = [
    'معاذ أحمد',
    'أحمد وليد',
    'أحمد محمود',
    'إيمان محمد',
    'السيد أسامه',
    'سارة ربيع',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // عنوان الشاشة.
              Text(
                'عن',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 2.h),


              // هنا بنكبّر محتوى اللوجو ونقص الفراغات الزائدة حوله.
              SizedBox(
                width: double.infinity,
                height: 145.h,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    minHeight: 240.h,
                    maxHeight: 240.h,
                    child: Image.asset(
                      'assets/images/raffi.png',
                      width: double.infinity,
                      height: 240.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // بطاقة تعريف المشروع.
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 22.w,
                  vertical: 18.h,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF444444),
                      Color(0xFF130C08),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '“',
                      style: TextStyle(
                        fontSize: 52.sp,
                        height: 0.9,
                        color: const Color(0xFF8A4D31),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'رفّي هو مشروع بيجمع الكتب اللي بتحبها في مكتبة رقمية واحدة، ويساعدك تكتشف قراءات جديدة.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 14.sp,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              // عنوان فريق العمل وعدد الأعضاء.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'فريق العمل',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${teamMembers.length} أعضاء',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF5C4031),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // كروت الفريق: الرقم على اليمين والاسم بمحاذاة قريبة منه.
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: teamMembers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  mainAxisExtent: 60.h,
                ),
                itemBuilder: (context, index) {
                  final number = index + 1;

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.textPrimary.withValues(alpha: 0.10),
                        width: 0.6,
                      ),
                    ),
                    child: Row(
                      children: [
                        // في اتجاه RTL، أول عنصر يظهر على اليمين.
                        Container(
                          width: 38.w,
                          height: 38.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _memberColor(number),
                          ),
                          child: Text(
                            '$number',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: number == 3 || number == 6
                                  ? AppColors.background
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),

                        SizedBox(width: 8.w),

                        // هنا قرّبنا الاسم من الدائرة بمحاذاته ناحية اليمين.
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teamMembers[index],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'فريق رفّي',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 10.sp,
                                  color: const Color(0xFF5C4031),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 24.h),

              // قسم DEPI: النص يبدأ من اليمين وصورة الكتاب على الشمال.
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 14.h,
                  bottom: 10.h,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.textPrimary.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // النص أولًا، لذلك يظهر على اليمين في اتجاه RTL.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مشروع Flutter — DEPI',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'صُنع بشغف للكتب والقراءة',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12.sp,
                              color: const Color(0xFF866C5B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // صورة الكتاب في نهاية الـ Row، أي على الشمال في RTL.
                    Image.asset(
                      'assets/images/boo3x.png',
                      width: 54.w,
                      height: 38.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // هنا حددنا ألوان دوائر أعضاء الفريق حسب رقم كل عضو.
  static Color _memberColor(int number) {
    switch (number) {
      case 3:
      case 6:
        return const Color(0xFF5C4031);
      case 1:
      case 4:
        return const Color(0xFFF4E2D4);
      case 2:
      case 5:
      default:
        return const Color(0xFFE7D7C2);
    }
  }
}
