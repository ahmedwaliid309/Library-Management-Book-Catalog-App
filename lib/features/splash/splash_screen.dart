import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:raffi/core/theme/app_colors.dart';
import 'package:raffi/features/onboarding/onboarding_screen.dart';

import '../../core/router/app_router.dart';
import '../../core/widgets/placeholder_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// المسؤول: إيمان
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;

      context.go(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       body: Center(
         child: Padding(
           padding: EdgeInsetsGeometry.symmetric(vertical:77.r),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               SizedBox(
                 width: double.infinity.w,
                 height: 389.h,
                 child: Image.asset('assets/images/raffi.png', fit:BoxFit.cover,),
               ),

               SpinKitThreeBounce(
                 color: AppColors.primary,
                 size: 30.0,
               ),

               SizedBox(
                 width: 282.w,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Image.asset('assets/images/ShelfIllustration.png'),
                   ],
                 ),
               )
             ],
           ),
         ),
       ),
     );
  }
}