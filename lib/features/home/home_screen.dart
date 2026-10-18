import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raffi/core/router/app_router.dart';
import 'package:raffi/data/book_section.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// موديل الكتاب - بيتبني مباشرة من الـ JSON اللي راجع من الـ API
/// لو أسماء الحقول عندك مختلفة عدّلها في fromJson بس.
class BookItem {
  final int id;
  final String image; // رابط الغلاف (http) أو asset path
  final String title;
  final String author;
  final bool isFavorite;

  const BookItem({
    required this.id,
    required this.image,
    required this.title,
    required this.author,
    this.isFavorite = false,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    final dynamic rawAuthor = json['author'] ?? json['author_name'];

    return BookItem(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: (json['title'] ?? json['name'] ?? '').toString(),
      // لو الـ API راجع المؤلف كـ object فيه name
      author: rawAuthor is Map
          ? (rawAuthor['name'] ?? '').toString()
          : (rawAuthor ?? '').toString(),
      image:
      (json['image'] ?? json['cover'] ?? json['cover_url'] ?? '').toString(),
      isFavorite: json['is_favorite'] == true,
    );
  }
}

/// مكان الاتصال بالـ API.
/// لما الـ API يجهز: خلّي useMock = false وكمّل الجزء الخاص بالـ request.
/// (يفضّل تنقل الكلاس ده لملف لوحده جوه data/)
class BooksRepository {
  static const bool useMock = true;

  Future<List<BookItem>> getRecentBooks() => _fetch('books/recent');

  Future<List<BookItem>> getRecommendedBooks() => _fetch('books/recommended');

  Future<List<BookItem>> _fetch(String endpoint) async {
    if (useMock) {
      // داتا تجريبية مؤقتة لحد ما الـ API يجهز
      await Future.delayed(const Duration(milliseconds: 800));
      final base = endpoint.contains('recent') ? 0 : 3;
      final List<Map<String, dynamic>> json = [
        {
          'id': base + 1,
          'title': 'عدّاء الطائرة الورقية',
          'author': 'خالد حسيني',
          'image': 'assets/images/Frame 22.png',
        },
        {
          'id': base + 2,
          'title': 'في ممر الفئران',
          'author': 'أحمد خالد توفيق',
          'image': 'assets/images/black.png',
        },
        {
          'id': base + 3,
          'title': 'قضية ست الحسن',
          'author': 'ميرنا المهدي',
          'image': 'assets/images/satel7osn.png',
        },
      ];
      return json.map(BookItem.fromJson).toList();
    }

    // ===== مثال للاتصال الحقيقي (بعد إضافة package: http) =====
    // final res = await http.get(Uri.parse('https://YOUR_API/$endpoint'));
    // if (res.statusCode != 200) throw Exception('Failed: ${res.statusCode}');
    // final decoded = jsonDecode(res.body);
    // final List list = decoded is List ? decoded : decoded['data'];
    // return list
    //     .map((e) => BookItem.fromJson(e as Map<String, dynamic>))
    //     .toList();
    throw UnimplementedError('اربط الـ API هنا');
  }
}

/// حالة كل سيكشن (تحميل / خطأ / داتا)
class _BooksState {
  List<BookItem> items = [];
  bool isLoading = true;
  String? error;
}

class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  final Set<int> favoriteBooks = {};

  // أبعاد فريم الكتاب (ثابتة عشان الشكل يفضل ثابت مع أي صورة جاية من الـ API)
  static const double _bookWidth = 105;
  static const double _bookHeight = 150;

  static const double _bookGap = 18;

  final BooksRepository _repo = BooksRepository();
  final _BooksState recent = _BooksState();
  final _BooksState recommended = _BooksState();

  @override
  void initState() {
    super.initState();
    _loadRecent();
    _loadRecommended();
  }

  Future<void> _load(
      _BooksState state,
      Future<List<BookItem>> Function() fetch,
      ) async {
    setState(() {
      state.isLoading = true;
      state.error = null;
    });

    try {
      final items = await fetch();
      if (!mounted) return;
      setState(() {
        state.items = items;
        state.isLoading = false;
        for (final b in items) {
          if (b.isFavorite) favoriteBooks.add(b.id);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        state.isLoading = false;
        state.error = 'حصل خطأ أثناء تحميل الكتب';
      });
    }
  }

  Future<void> _loadRecent() => _load(recent, _repo.getRecentBooks);

  Future<void> _loadRecommended() =>
      _load(recommended, _repo.getRecommendedBooks);

  Future<void> _refreshAll() =>
      Future.wait([_loadRecent(), _loadRecommended()]);

  // ===== فلتر =====
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

  // ===== Navigation =====
  void _openBookDetails(BookItem book) {
    // غيّر AppRoutes.bookDetails لاسم الراوت عندك في app_router.dart
    context.push(AppRoutes.bookDetails, extra: book);
  }

  void _openSearch() {
    context.push(AppRoutes.search);
  }

  // ===== صورة الكتاب داخل فريم (تدعم asset و network) =====
  Widget _bookCover(String path) {
    final Widget placeholder = Container(
      color: const Color(0xFFF0E9E0),
      child: const Center(
        child: Icon(Icons.menu_book_rounded, color: Color(0xFF947D69)),
      ),
    );

    if (path.isEmpty) return placeholder;

    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
        loadingBuilder: (context, child, progress) =>
        progress == null ? child : placeholder,
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }

  Widget bookImage(BookItem book) {
    final bool isFavorite = favoriteBooks.contains(book.id);

    return SizedBox(
      width: _bookWidth,
      height: _bookHeight,
      child: Stack(
        children: [
          // الفريم - قابل للضغط
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _openBookDetails(book),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _bookCover(book.image),
              ),
            ),
          ),

          // زر المفضلة
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 21,
                onPressed: () {
                  setState(() {
                    if (isFavorite) {
                      favoriteBooks.remove(book.id);
                    } else {
                      favoriteBooks.add(book.id);
                    }
                  });
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== سيكشن الكتب (تحميل / خطأ / فاضي / داتا) =====
  Widget _booksSection(_BooksState state, VoidCallback onRetry) {
    if (state.isLoading) return _booksLoading();
    if (state.error != null) {
      return _booksMessage(state.error!, onRetry: onRetry);
    }
    if (state.items.isEmpty) return _booksMessage('لا توجد كتب حالياً');

    final books = state.items;
    // عرض الرف = من أول كتاب لحد آخر كتاب بالظبط
    final shelfWidth =
        books.length * _bookWidth + (books.length - 1) * _bookGap;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الفريمات
          Row(
            children: [
              for (int i = 0; i < books.length; i++) ...[
                if (i != 0) const SizedBox(width: _bookGap),
                bookImage(books[i]),
              ],
            ],
          ),

          // الرف (بيبدأ من أول كتاب وينتهي عند آخر كتاب)
          SizedBox(
            width: shelfWidth,
            height: 10,
            child: Image.asset('assets/images/roof2.png', fit: BoxFit.fill),
          ),

          const SizedBox(height: 10),

          // العناوين والمؤلفين
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < books.length; i++) ...[
                if (i != 0) const SizedBox(width: _bookGap),
                _bookInfo(books[i]),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _bookInfo(BookItem book) {
    return GestureDetector(
      onTap: () => _openBookDetails(book),
      child: SizedBox(
        width: _bookWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // شكل التحميل (Skeleton)
  Widget _booksLoading() {
    Widget bar(double width, double height) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF0E9E0),
        borderRadius: BorderRadius.circular(6),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (i) {
          return Padding(
            padding: EdgeInsets.only(left: i == 2 ? 0 : _bookGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: _bookWidth,
                  height: _bookHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E9E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 20),
                bar(_bookWidth - 20, 12),
                const SizedBox(height: 6),
                bar(_bookWidth - 45, 10),
              ],
            ),
          );
        }),
      ),
    );
  }

  // رسالة خطأ أو لا يوجد كتب
  Widget _booksMessage(String message, {VoidCallback? onRetry}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFC46627),
                ),
              ),
            ),
        ],
      ),
    );
  }

  ButtonStyle filterButtonStyle(bool isSelected) {
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected ? const Color(0xFFC46627) : Colors.white,
      foregroundColor: isSelected ? Colors.white : const Color(0xFF49372D),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      minimumSize: const Size(0, 44),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isSelected ? const Color(0xFFC46627) : const Color(0xFFF0E9E0),
        ),
      ),
      textStyle: TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ===== الـ Bottom Sheet بتاع الفلتر =====
  void _showFilterSheet() {
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: AppColors.background,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // الخط العلوي
                            Center(
                              child: Container(
                                height: 5,
                                width: 55,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE7D7C2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              textDirection: TextDirection.rtl,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'خصّص بحثك',
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontFamily,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'اختار الكتب الأقرب لذوقك',
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontFamily,
                                          fontSize: 16,
                                          color: const Color(0xFF947D69),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Color(0xFFF0E9E0),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.close,
                                        color: Color(0xFF49372D),
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
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Wrap(
                              textDirection: TextDirection.rtl,
                              spacing: 6,
                              runSpacing: 8,
                              children: List.generate(Types.length, (index) {
                                final isSelected = selectedType == index;
                                return ElevatedButton(
                                  onPressed: () {
                                    setSheetState(() {
                                      selectedType = index;
                                    });
                                  },
                                  style: filterButtonStyle(isSelected),
                                  child: Text(Types[index]),
                                );
                              }),
                            ),

                            const SizedBox(height: 36),

                            Text(
                              'حالة القراءة',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Wrap(
                              textDirection: TextDirection.rtl,
                              spacing: 6,
                              runSpacing: 8,
                              children:
                              List.generate(readingTypes.length, (index) {
                                final isSelected =
                                    selectedReadingStatus == index;
                                return ElevatedButton(
                                  onPressed: () {
                                    setSheetState(() {
                                      selectedReadingStatus = index;
                                    });
                                  },
                                  style: filterButtonStyle(isSelected),
                                  child: Text(readingTypes[index]),
                                );
                              }),
                            ),

                            const SizedBox(height: 40),

                            // حفظ وإلغاء
                            Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 66,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          currentIndex = selectedType;
                                          currentReadingStatus =
                                              selectedReadingStatus;
                                        });
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        const Color(0xFFC46627),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        'حفظ',
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontFamily,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: SizedBox(
                                    height: 66,
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                        const Color(0xFFC46627),
                                        side: const BorderSide(
                                          color: Color(0xFFC46627),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        'إلغاء',
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontFamily,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
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
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshAll,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'أهلا بيك فى رفّي 🤎',
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
                      padding: const EdgeInsets.only(right: 16),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            onPressed: _showFilterSheet,
                            icon: const Icon(Icons.filter_list),
                            color: Colors.black,
                            iconSize: 28,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ===== البانر =====
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF74503B), Color(0xFF2B1D15)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 14, right: 18),
                            alignment: Alignment.topRight,
                            child: Text(
                              'مجموعتك تبدأ من هنا',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFBF6428),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

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

                          const SizedBox(height: 6),

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
                                    // ===== زر "اكتشف الكتب" → صفحة search =====
                                    child: GestureDetector(
                                      onTap: _openSearch,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFCF8EE),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'اكتشف الكتب',
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontFamily,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF2B1D15),
                                          ),
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

                  const SizedBox(height: 10),

                  // ===== آخر ما تصفحت =====
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
                            context.push(
                              AppRoutes.search,
                              extra: BookSection.recent,
                            );
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

                  const SizedBox(height: 6),

                  _booksSection(recent, _loadRecent),

                  const SizedBox(height: 16),

                  // ===== قد يعجبك =====
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
                            context.push(
                              AppRoutes.search,
                              extra: BookSection.recommended,
                            );
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

                  const SizedBox(height: 10),

                  _booksSection(recommended, _loadRecommended),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}