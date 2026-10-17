import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import 'see_all_screen.dart';
import '../../core/theme/app_colors.dart';
import 'dart:ui';

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  List<String> Types = [
    'الكل',
    'رواية',
    'رومانسي',
    'غموض',
    'فانتازيا',
    'تطوير ذات',
    'تكنولوجيا',
  ];

  int currentIndex = 0;
  int currentReadingStatus = 0;

  final List<String> readingTypes = [
    'الكل',
    'أريد قراءته',
    'أقرأ حالياً',
    'مكتمل',
  ];

  ButtonStyle filterButtonStyle(bool isSelected) {
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected
          ? const Color(0xFFC46627)
          : Colors.white,
      foregroundColor: isSelected
          ? Colors.white
          : const Color(0xFF49372D),
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      minimumSize: const Size(0, 44),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isSelected
              ? const Color(0xFFC46627)
              : const Color(0xFFF0E9E0),
        ),
      ),
      textStyle: TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 16,
                    left: 16,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'أهلا بيك فى رقّي 🤎',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text(
                      'جاهز تكتشف كتابك الجاي؟',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'ابحث عن كتاب او مؤلف ...',
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black.withOpacity(.1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.black.withOpacity(0.25),
                              isScrollControlled: true,
                              builder: (context) {
                                int selectedType = currentIndex;
                                int selectedReadingStatus = 0;

                                return StatefulBuilder(
                                  builder: (context, setSheetState) {
                                    return ClipRRect(
                                      borderRadius:
                                      const BorderRadius.vertical(
                                        top: Radius.circular(32),
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 8,
                                          sigmaY: 8,
                                        ),
                                        child: Container(
                                          color: AppColors.background,
                                          child: SafeArea(
                                            top: false,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                24,
                                                16,
                                                24,
                                                16,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .stretch,
                                                  children: [
                                                    // الخط العلوي
                                                    Center(
                                                      child: Container(
                                                        height: 5,
                                                        width: 55,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: const Color(
                                                            0xFFE7D7C2,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(4),
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20),

                                                    Row(
                                                      textDirection:
                                                      TextDirection.rtl,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                            children: [
                                                              Text(
                                                                'خصّص بحثك',
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  AppTheme
                                                                      .fontFamily,
                                                                  fontSize: 26,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  color: AppColors
                                                                      .textPrimary,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                'اختار الكتب الأقرب لذوقك',
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  AppTheme
                                                                      .fontFamily,
                                                                  fontSize: 16,
                                                                  color: const Color(
                                                                    0xFF947D69,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                          width: 16,
                                                        ),


                                                        SizedBox(
                                                          width: 60,
                                                          height: 60,
                                                          child: OutlinedButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                  context,
                                                                ),
                                                            style:
                                                            OutlinedButton
                                                                .styleFrom(
                                                              padding:
                                                              EdgeInsets
                                                                  .zero,
                                                              backgroundColor:
                                                              Colors.white,
                                                              side:
                                                              const BorderSide(
                                                                color: Color(
                                                                  0xFFF0E9E0,
                                                                ),
                                                              ),
                                                              shape:
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                  20,
                                                                ),
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Color(
                                                                  0xFF49372D,
                                                                ),
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 36),

                                                    Text(
                                                      'التصنيف',
                                                      textAlign:
                                                      TextAlign.right,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme
                                                            .fontFamily,
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 16),

                                                    Wrap(
                                                      textDirection:
                                                      TextDirection.rtl,
                                                      spacing: 6,
                                                      runSpacing: 8,
                                                      children: List.generate(
                                                        Types.length,
                                                            (index) {
                                                          final isSelected =
                                                              selectedType ==
                                                                  index;

                                                          return ElevatedButton(
                                                            onPressed: () {
                                                              setSheetState(() {
                                                                selectedType =
                                                                    index;
                                                              });
                                                            },
                                                            style:
                                                            filterButtonStyle(
                                                              isSelected,
                                                            ),
                                                            child: Text(
                                                              Types[index],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    const SizedBox(height: 36),

                                                    Text(
                                                      'حالة القراءة',
                                                      textAlign:
                                                      TextAlign.right,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme
                                                            .fontFamily,
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 16),

                                                    Wrap(
                                                      textDirection:
                                                      TextDirection.rtl,
                                                      spacing: 6,
                                                      runSpacing: 8,
                                                      children: List.generate(
                                                        readingTypes.length,
                                                            (index) {
                                                          final isSelected =
                                                              selectedReadingStatus ==
                                                                  index;

                                                          return ElevatedButton(
                                                            onPressed: () {
                                                              setSheetState(() {
                                                                selectedReadingStatus =
                                                                    index;
                                                              });
                                                            },
                                                            style:
                                                            filterButtonStyle(
                                                              isSelected,
                                                            ),
                                                            child: Text(
                                                              readingTypes[
                                                              index],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    const SizedBox(height: 40),

                                                    // حفظ وإلغاء
                                                    Row(
                                                      textDirection:
                                                      TextDirection.rtl,
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 66,
                                                            child:
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  currentIndex =
                                                                      selectedType;
                                                                  currentReadingStatus =
                                                                      selectedReadingStatus;
                                                                });

                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              style:
                                                              ElevatedButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                const Color(
                                                                  0xFFC46627,
                                                                ),
                                                                foregroundColor:
                                                                Colors.white,
                                                                elevation: 0,
                                                                shape:
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                    16,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                'حفظ',
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  AppTheme
                                                                      .fontFamily,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                          width: 40,
                                                        ),

                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 66,
                                                            child:
                                                            OutlinedButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                              style:
                                                              OutlinedButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                const Color(
                                                                  0xFFC46627,
                                                                ),
                                                                side:
                                                                const BorderSide(
                                                                  color: Color(
                                                                    0xFFC46627,
                                                                  ),
                                                                ),
                                                                shape:
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                    16,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                'إلغاء',
                                                                style:
                                                                TextStyle(
                                                                  fontFamily:
                                                                  AppTheme
                                                                      .fontFamily,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.filter_list),
                          color: Colors.black,
                          iconSize: 28,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: [
                          Color(0xFF352116),
                          Color(0xFF5D3A2A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 14,
                            right: 18,
                          ),
                          alignment: Alignment.topRight,
                          child: Text(
                            'مجموعتك تبدأ من هنا',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFFBF6428),
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          alignment: Alignment.topRight,
                          child: Text(
                            'رحلتك مع القراءة تبدأ هنا',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          alignment: Alignment.topRight,
                          child: Text(
                            'اكتشف حكايتك القادمة',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 12,
                                    bottom: 8,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff0FCF8EE),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'اكتشف الكتب',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff02B1D15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Image.asset(
                                'assets/images/book.png',
                                width: 140,
                                height: 100,
                                fit: BoxFit.contain,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'آخر ما تصفحت ',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SeeAllScreen(),
                            ),
                          );
                          // context.push(AppRoutes.search, extra: BookSection.recent);
                        },
                        child: Text(
                          'عرض الكل',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 6),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 150,
                          child: Image.asset(
                            'assets/images/Frame 22.png',
                          ),
                        ),
                        SizedBox(width: 18),
                        Container(
                          height: 150,
                          child: Image.asset(
                            'assets/images/black.png',
                          ),
                        ),
                        SizedBox(width: 18),
                        Container(
                          height: 150,
                          child: Image.asset(
                            'assets/images/satel7osn.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 10,
                  width: 550,
                  child: Image.asset(
                    'assets/images/roof.png',
                  ),
                ),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              'عدّاء الطائرة الورقية',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            alignment: Alignment.topRight,
                            child: Text(
                              'خالد حسيني',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 18),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              'في ممر الفئران',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            alignment: Alignment.topRight,
                            child: Text(
                              'أحمد خالد توفيق',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 18),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              'قضية ست الحسن',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            alignment: Alignment.topRight,
                            child: Text(
                              'ميرنا المهدي',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'قد يعجبك ',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SeeAllScreen(),
                            ),
                          );
                          // context.push(AppRoutes.search, extra: BookSection.recommended);
                        },
                        child: Text(
                          'عرض الكل',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 150,
                          child: Image.asset(
                            'assets/images/Frame 22.png',
                          ),
                        ),
                        SizedBox(width: 18),
                        Container(
                          height: 150,
                          child: Image.asset(
                            'assets/images/black.png',
                          ),
                        ),
                        SizedBox(width: 18),
                        Container(
                          height: 150,
                          child: Image.asset(
                            'assets/images/satel7osn.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                Container(
                  height: 10,
                  width: 550,
                  child: Image.asset(
                    'assets/images/roof.png',
                  ),
                ),


                SizedBox(height: 6),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              'عدّاء الطائرة الورقية',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            alignment: Alignment.topRight,
                            child: Text(
                              'خالد حسيني',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 18),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              'في ممر الفئران',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            alignment: Alignment.topRight,
                            child: Text(
                              'أحمد خالد توفيق',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 18),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              'قضية ست الحسن',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            alignment: Alignment.topRight,
                            child: Text(
                              'ميرنا المهدي',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}