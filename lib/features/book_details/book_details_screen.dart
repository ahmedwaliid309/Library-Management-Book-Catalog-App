import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/placeholder_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/book_repository.dart';
import '../../data/models/book.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/error_view.dart';
import 'package:raffi/features/favorites/favorites_provider.dart';
import 'package:provider/provider.dart';



class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key, required this.bookId});

  final String bookId;

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {

  bool isSelected = false;
  int selectedBookStatus = -1;
  List<String> buttons = [
    'أريد قراءته',
    'أقرأ حاليا',
    'مكتمل',
  ];

  Book? book;
  bool isLoading = true;
  bool isDescriptionExpanded = false;

  ImageProvider getCoverImage(Book book) {
    if (book.coverAsset.startsWith('https://') ||
        book.coverAsset.startsWith('http://')) {
      return NetworkImage(book.coverAsset);
    }

    if (book.coverAsset.isNotEmpty) {
      return AssetImage(book.coverAsset);
    }

    return const AssetImage(
      'assets/images/الامير الصغير.png',
    );
  }


  String formatDescription(String description) {
    return description

        .replaceAll(RegExp(r'<[^>]*>'), ' ')


        .replaceAll('&quot;', '"')
        .replaceAll('quot&', '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ')


        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }


  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    final result = await BookRepository().details(widget.bookId);

    if (!mounted) return;

    setState(() {
      book = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: LoadingView(
          message: 'جاري تحميل تفاصيل الكتاب...',
          icon: Icons.menu_book,
        ),
      );
    }

    if (book == null) {
      return Scaffold(
        body: ErrorView(
          title: 'تعذر تحميل تفاصيل الكتاب',
          message: 'حاول الاتصال بالانترنت مرة اخري',
          icon: Icons.menu_book_rounded,
          onRetry: _loadBook,
        ),
      );
    }

    final currentBook = book!;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(currentBook.id);

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
                                  onPressed: () async {
                                  await context.read<FavoritesProvider>().toggle(currentBook);
                                  },
                                  icon: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if(isFavorite == true)
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
                                      image: getCoverImage(currentBook),
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
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    SizedBox(
                                      width: 254.w,
                                      child: Text(
                                        currentBook.title,
                                        textAlign: TextAlign.center,
                                        softWrap: true,
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
                                        currentBook.author,
                                        textAlign: TextAlign.center,
                                        softWrap: true,
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
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              width: 0.54,
                              color: AppColors.textPrimary.withValues(alpha: 0.1),
                            ),
                          ),
                          child:
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,

                              children: [
                                // التصنيف
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
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
                                      SizedBox(height: 4.h),
                                      Text(
                                        currentBook.category.isNotEmpty
                                            ? currentBook.category
                                            .split(RegExp(r'\s*&\s*|\s*,\s*'))
                                            .where((category) => category.trim().isNotEmpty)
                                            .join('\n')
                                            : 'غير متاح',
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 12.sp,
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.w700,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 1.w,
                                  height: 30.h,
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  color: const Color(0x332B1D15),
                                ),

                                // سنة النشر
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
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
                                      SizedBox(height: 4.h),
                                      Text(
                                        currentBook.publishedDate.length >= 4
                                            ? currentBook.publishedDate.substring(0, 4)
                                            : 'غير متاح',
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
                                ),

                                Container(
                                  width: 1.w,
                                  height: 30.h,
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  color: const Color(0x332B1D15),
                                ),

                                // عدد الصفحات
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
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
                                      SizedBox(height: 4.h),
                                      Text(
                                        currentBook.pages > 0
                                            ? '${currentBook.pages}'
                                            : 'غير متاح',
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
                                ),
                              ],
                            ),
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
                                  currentBook.description.isNotEmpty
                                      ? formatDescription(currentBook.description)
                                      : 'لا يتوفر وصف لهذا الكتاب.',
                                  maxLines: isDescriptionExpanded ? null : 5,
                                  overflow: isDescriptionExpanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14.sp,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),

                              ),

                              if (currentBook.description.isNotEmpty &&
                                  formatDescription(currentBook.description).length > 250)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isDescriptionExpanded = !isDescriptionExpanded;
                                      });
                                    },
                                    child: Text(
                                      isDescriptionExpanded ? 'اقرأ أقل' : 'اقرأ المزيد',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14.sp,
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.w700,
                                      ),
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
                                            selectedBookStatus = 0;
                                          });
                                        },
                                        child: Container(
                                          width: 98.w,
                                          height: 60.h,
                                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                                          decoration: BoxDecoration(
                                              color: selectedBookStatus == 0
                                                  ? Color(0xFFF4E2D4)
                                                  : Color(0xFFF6EFE1),
                                              border: selectedBookStatus == 0
                                                  ? Border.all(
                                                color: Color(0x3DBF6428).withValues(alpha: 0.53),
                                              )
                                                  : null,
                                              borderRadius: BorderRadius.circular(10.r)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.bookmark_border,color: selectedBookStatus == 0
                                                  ? AppColors.primary
                                                  :AppColors.textSecondary,),
                                              SizedBox(height: 2.h,),
                                              Text(
                                                'أريد قراءته',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: selectedBookStatus == 0
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
                                            selectedBookStatus = 1;
                                          });
                                        },
                                        child: Container(
                                          width: 98.w,
                                          height: 60.h,
                                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                                          decoration: BoxDecoration(
                                              color: selectedBookStatus == 1
                                                  ? Color(0xFFF4E2D4)
                                                  : Color(0xFFF6EFE1),
                                              border: selectedBookStatus == 1
                                                  ? Border.all(
                                                color: Color(0x3DBF6428).withValues(alpha: 0.53),
                                              )
                                                  : null,
                                              borderRadius: BorderRadius.circular(10.r)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.menu_book_outlined,color: selectedBookStatus == 1
                                                ? AppColors.primary
                                                :AppColors.textSecondary,),
                                              SizedBox(height: 2.h,),
                                              Text(
                                                'أقرأ حالياً',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: selectedBookStatus == 1
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
                                            selectedBookStatus = 2;
                                          });
                                        },
                                        child: Container(
                                          width: 98.w,
                                          height: 60.h,
                                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                                          decoration: BoxDecoration(
                                              color: selectedBookStatus == 2
                                                  ? Color(0xFFF4E2D4)
                                                  : Color(0xFFF6EFE1),
                                              border: selectedBookStatus == 2
                                                  ? Border.all(
                                                color: Color(0x3DBF6428).withValues(alpha: 0.53),
                                              )
                                                  : null,
                                              borderRadius: BorderRadius.circular(10.r)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.check_rounded,color: selectedBookStatus == 2
                                                  ? AppColors.primary
                                                  :AppColors.textSecondary,),
                                              SizedBox(height: 2.h,),
                                              Text(
                                                'مكتمل',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: selectedBookStatus == 2
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
                                  ElevatedButton(
                                      onPressed: () => context.go(AppRoutes.library),
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
