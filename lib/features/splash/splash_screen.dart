import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/widgets/placeholder_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

// المسؤول: إيمان
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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

               SizedBox(
                 width: 282.w,
                 height: 167.h,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     //SvgPicture.asset('assets/images/Shelf.svg'),
                     Image.asset('assets/images/ShelfIllustration.png'),
                     ElevatedButton(
                       onPressed: ()=> context.go(AppRoutes.onboarding),
                       child: const Text(
                           'اكتشف رفّي',
                       ),
                     )
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