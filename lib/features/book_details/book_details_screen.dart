import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/placeholder_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';



// المسؤول: إيمان
class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key, required this.bookId});

  final String bookId;

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {

  bool isSelected = false;
  bool bookSelected = false;
  bool bookSelected1 = false;
  bool bookSelected2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              bottom: 24.h,
              left: 24.w,
              right: 24.w,
            ),
            child:
                Stack(
                   //clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [

                    Positioned(
                      top: 55.h,
                      child: Container(
                        width: 270.w,
                        height: 270.h,
                        decoration: ShapeDecoration(
                            color: Color(0xffF4E2D4),
                            shape: OvalBorder()),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 46.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      isSelected = !isSelected;
                                    });
                                  },
                                  icon: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if(isSelected == true)
                                        Icon(
                                          Icons.favorite, color: AppColors.primary,
                                        ),
                                      Icon(Icons.favorite_border, color: AppColors.textPrimary)
                                    ],
                                  )
                              ),
                            ),
                            Text('تفاصيل الكتاب',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20.sp,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              width: 46.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => context.go(AppRoutes.home),
                                icon: Icon(Icons.arrow_forward_rounded, color: AppColors.textPrimary,),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h,),
                        SizedBox(
                          width: 254.w,
                          height: 387.h,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(0.05),
                                  width: 173.w,
                                  height: 260.h,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/الامير الصغير.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.r),
                                        topRight: Radius.circular(6.r),
                                        bottomLeft: Radius.circular(12.r),
                                        bottomRight: Radius.circular(6.r),
                                      ),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: AppColors.textPrimary,
                                        blurRadius: 0,
                                        offset: Offset(8, 0),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  )
                              ),
                              SizedBox(height: 8.h,),
                              Container(
                                width: 215.w,
                                height: 10.h,
                                decoration: ShapeDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment(0.50, -0.00),
                                        end: Alignment(0.50, 1.00),
                                        colors:[const Color(0xFF74503B), AppColors.textPrimary]
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadiusGeometry.only(
                                          topLeft: Radius.circular(2.r),
                                          topRight: Radius.circular(2.r),
                                          bottomLeft: Radius.circular(6.r),
                                          bottomRight: Radius.circular(6.r),
                                        )
                                    )
                                ),
                              ),
                              Container(
                                width: 164,
                                height: 6,
                                decoration: BoxDecoration(color: const Color(0x192B1D15)),
                              ),
                              SizedBox(height: 6.h,),
                              SizedBox(
                                width: double.infinity.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    SizedBox(
                                      width: 254.w,
                                      child: Text(
                                        'اللأمير الصغير',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 32.sp,
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 254.w,
                                      child: Text(
                                        'انطوان دو سانت إكزوبيري\n',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 16.sp,
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity.w,
                          height: 74.h,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              width: 0.54,
                              color: AppColors.textPrimary.withValues(alpha: 0.1),
                            )
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'التصنيف',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12.sp,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2.h,),
                                  Text(
                                    'رواية',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13.sp,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1.w,
                                height: 30.h,
                                decoration: BoxDecoration(color: const Color(0x332B1D15)),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'سنة النشر',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12.sp,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2.h,),
                                  Text(
                                    '1943',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13.sp,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1.w,
                                height: 30.h,
                                decoration: BoxDecoration(color: const Color(0x332B1D15)),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'الصفحات',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12.sp,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2.h,),
                                  Text(
                                    '96',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13.sp,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),


                            ],
                          ),
                        ),

                        SizedBox(height: 24.h,),
                        SizedBox(
                          width: double.infinity.w,
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity.w,
                                child: Text(
                                  'عن الكتاب',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 20.sp,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h,),
                              SizedBox(
                                width: double.infinity.w,
                                child: Text(
                                  'تروي «الأمير الصغير» رحلة طفل بين الكواكب، يكتشف خلالها معاني الصداقة والحب والمسؤولية، ويتعلم أن أهم الأشياء لا تُرى بالعين وحدها.',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14.sp,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 28.h,),
                        SizedBox(
                          width: double.infinity.w,
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity.w,
                                child: Text(
                                  'عن المؤلف',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 20.sp,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h,),
                              SizedBox(
                                width: double.infinity.w,
                                child: Text(
                                  'أنطوان دو سانت إكزوبيري كاتب وطيار فرنسي، اشتهر بروايته «الأمير الصغير» التي نُشرت عام 1943، وتتناول الصداقة والحب ومعنى الحياة.',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14.sp,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 28.h,),
                        Container(
                          width: double.infinity.w,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.onPrimary,
                            border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'أضف إلى مكتبتي',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 16.sp,
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 4.h,),
                                      Text(
                                        'اختار الرف المناسب للكتاب',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12.sp,
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/books.svg',
                                    width: 24.w,
                                    height: 24.h,
                                  )

                                ],
                              ),
                              SizedBox(height: 10.h,),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            bookSelected = !bookSelected;
                                          });
                                        },
                                        child: Container(
                                          width: 98.w,
                                          height: 60.h,
                                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                                          decoration: BoxDecoration(
                                              color: bookSelected
                                                  ? Color(0xFFF4E2D4)
                                                  : Color(0xFFF6EFE1),
                                              border: bookSelected
                                                  ? Border.all(
                                                color: Color(0x3DBF6428).withValues(alpha: 0.53),
                                              )
                                                  : null,
                                              borderRadius: BorderRadius.circular(10.r)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.bookmark_border,color: bookSelected
                                                  ? AppColors.primary
                                                  :AppColors.textSecondary,),
                                              SizedBox(height: 2.h,),
                                              Text(
                                                'أريد قراءته',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: bookSelected
                                                      ? AppColors.primary
                                                      :AppColors.textSecondary,
                                                  fontSize: 10,
                                                  fontFamily: 'Tajawal',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            bookSelected1 = !bookSelected1;
                                          });
                                        },
                                        child: Container(
                                          width: 98.w,
                                          height: 60.h,
                                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                                          decoration: BoxDecoration(
                                              color: bookSelected1
                                                  ? Color(0xFFF4E2D4)
                                                  : Color(0xFFF6EFE1),
                                              border: bookSelected1
                                                  ? Border.all(
                                                color: Color(0x3DBF6428).withValues(alpha: 0.53),
                                              )
                                                  : null,
                                              borderRadius: BorderRadius.circular(10.r)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.menu_book_outlined,color: bookSelected1
                                                ? AppColors.primary
                                                :AppColors.textSecondary,),
                                              SizedBox(height: 2.h,),
                                              Text(
                                                'أقرأ حالياً',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: bookSelected1
                                                      ? AppColors.primary
                                                      :AppColors.textSecondary,
                                                  fontSize: 10,
                                                  fontFamily: 'Tajawal',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            bookSelected2 = !bookSelected2;
                                          });
                                        },
                                        child: Container(
                                          width: 98.w,
                                          height: 60.h,
                                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                                          decoration: BoxDecoration(
                                              color: bookSelected2
                                                  ? Color(0xFFF4E2D4)
                                                  : Color(0xFFF6EFE1),
                                              border: bookSelected2
                                                  ? Border.all(
                                                color: Color(0x3DBF6428).withValues(alpha: 0.53),
                                              )
                                                  : null,
                                              borderRadius: BorderRadius.circular(10.r)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.check_rounded,color: bookSelected2
                                                  ? AppColors.primary
                                                  :AppColors.textSecondary,),
                                              SizedBox(height: 2.h,),
                                              Text(
                                                'مكتمل',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: bookSelected2
                                                      ? AppColors.primary
                                                      :AppColors.textSecondary,
                                                  fontSize: 10,
                                                  fontFamily: 'Tajawal',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h,),
                                  ElevatedButton(onPressed: (){},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        spacing: 10.w,
                                        children: [
                                          Text('أضف إلى مكتبتى'),
                                          Icon(Icons.add_rounded,size: 24.w,),
                                        ],
                                      )
                                  )
                                ],
                              )


                            ],
                          ),
                        ),
                        SizedBox(height: 24.h,),
                        ElevatedButton(
                            onPressed: () => context.go(AppRoutes.favorites),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10.w,
                              children: [
                                Text('أضف إلى المفضلة'),
                                Icon(Icons.favorite_border,size: 24.w,),
                              ],
                            )
                        )


                      ],
                    ),

                  ],
                )

          )
      )));
  }
}

// PlaceholderScreen(
// title: 'تفاصيل الكتاب (#$bookId)',
// owner: 'إيمان',