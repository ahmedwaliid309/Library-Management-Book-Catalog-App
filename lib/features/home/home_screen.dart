import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raffi/core/router/app_router.dart';
import 'package:raffi/data/book_section.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

import 'package:provider/provider.dart';
import 'package:raffi/data/book_repository.dart';
import 'package:raffi/data/mock_books.dart';
import 'package:raffi/data/models/book.dart';
import 'package:raffi/providers/favorites_provider.dart';
import 'package:raffi/providers/history_provider.dart';
import 'package:raffi/core/widgets/book_card.dart';

class BookItem {
  final String id;
  final String image;
  final String title;
  final String author;
  final String category;
  final String readingStatus;
  final bool isFavorite;
  final Book? book;

  const BookItem({
    required this.id,
    required this.image,
    required this.title,
    required this.author,
    this.category = '',
    this.readingStatus = 'الكل',
    this.isFavorite = false,
    this.book,
  });

  /// الكتاب الأصلي (للمفضلة)، أو نبنيه من البيانات المتاحة
  Book toBook() =>
      book ??
      Book(
        id: id,
        title: title,
        author: author,
        coverAsset: image,
        category: category,
      );

  factory BookItem.fromBook(Book book) => BookItem(
    id: book.id,
    image: book.coverAsset,
    title: book.title,
    author: book.author,
    category: book.category,
    book: book,
  );
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
  // المفضلة بقت مربوطة بـ FavoritesProvider (نفس مصدر صفحة المفضلة)
  bool _isFavorite(String id) =>
      context.read<FavoritesProvider>().isFavorite(id);

  void _toggleFavorite(BookItem item) =>
      context.read<FavoritesProvider>().toggle(item.toBook());

  // أبعاد فريم الكتاب (ثابتة عشان الشكل يفضل ثابت مع أي صورة جاية من الـ API)
  static const double _bookWidth = 105;
  static const double _bookHeight = 150;

  static const double _bookGap = 18;

  late final BookRepository _repo;
  final _BooksState recent = _BooksState();
  final _BooksState recommended = _BooksState();

  // بحث مباشر من الصفحة الرئيسية باستخدام نفس BookRepository المستخدم في صفحة البحث.
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _searchQuery = '';
  List<BookItem> _homeSearchResults = [];
  bool _isHomeSearching = false;
  int _searchRequestId = 0;

  @override
  void initState() {
    super.initState();
    // Provider.read لا يشترك في التغييرات، ومناسب لبدء الطلب مرة واحدة.
    _repo = context.read<BookRepository>();
    // رف "آخر ما تصفحت" بيتحدث لوحده من HistoryProvider (شوف build).
    _loadRecommended();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onHomeSearchChanged(String value) {
    _searchDebounce?.cancel();
    final query = value.trim();

    if (query.isEmpty) {
      _searchRequestId++;
      setState(() {
        _searchQuery = '';
        _homeSearchResults = [];
        _isHomeSearching = false;
      });
      return;
    }

    setState(() {
      _searchQuery = value;
      _isHomeSearching = true;
      _homeSearchResults = [];
    });

    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _searchHomeBooks(query);
    });
  }

  Future<void> _searchHomeBooks(String query) async {
    final requestId = ++_searchRequestId;
    try {
      // نفس مصدر البحث المستخدم في بقية التطبيق.
      final books = await _repo.search(query, pageSize: 20);
      if (!mounted || requestId != _searchRequestId ||
          _searchController.text.trim() != query) {
        return;
      }
      setState(() {
        _homeSearchResults = books.map(BookItem.fromBook).toList();
        _isHomeSearching = false;
      });
    } catch (_) {
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _homeSearchResults = [];
        _isHomeSearching = false;
      });
    }
  }

  Widget _homeSearchResultsSection() {
    if (_isHomeSearching) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 36),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_homeSearchResults.isEmpty) {
      return _booksMessage('مفيش نتائج للبحث ده، جرّب كلمة تانية');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: _homeSearchResults.map((book) {
          final isFavorite = _isFavorite(book.id);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 58,
                  height: 78,
                  child: _bookCover(book.image),
                ),
              ),
              title: Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              trailing: IconButton(
                tooltip: isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                onPressed: () => _toggleFavorite(book),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.primary : Colors.grey,
                ),
              ),
              onTap: () => _openBookDetails(book),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _load(
      _BooksState state,
      Future<List<Book>> Function() fetch,
      ) async {
    setState(() {
      state.isLoading = true;
      state.error = null;
    });

    try {
      final result = await fetch();
      final items = result.map(BookItem.fromBook).toList();
      if (!mounted) return;
      setState(() {
        state.items = items;
        state.isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        state.isLoading = false;
        state.error = 'حصل خطأ أثناء تحميل الكتب';
      });
    }
  }

  Future<void> _loadRecommended() => _load(
    recommended,
    // نفس كلمة البحث بتاعة "عرض الكل" لقسم "قد يعجبك".
    // لو الـ API رجّع قائمة فاضية نعرض الكتب التجريبية بدل شاشة فاضية.
    () async {
      final books = await _repo.search('أدب');
      return books.isNotEmpty ? books : MockBooks.recommended;
    },
  );

  // "آخر ما تصفحت" بيتحدث لوحده من HistoryProvider، فالسحب للتحديث للـ "قد يعجبك" بس.
  Future<void> _refreshAll() => _loadRecommended();

  // ===== فلتر =====
  final List<String> types = const [
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

  final List<String> readingTypes = const [
    'الكل',
    'أريد قراءته',
    'أقرأ حالياً',
    'مكتمل',
  ];

  List<BookItem> _filterBooks(List<BookItem> books) {
    final selectedCategory = types[currentIndex];

    return books.where((book) {
      final categoryMatches = selectedCategory == 'الكل' ||
          _categoryMatches(book.category, selectedCategory);
      // Book model الحالي لا يحتوي حالة القراءة؛ لذلك لا نُخفي نتائج API
      // اعتماداً على حالة غير متوفرة في البيانات. يظل اختيار الحالة محفوظاً للربط لاحقاً.
      return categoryMatches;
    }).toList();
  }

  bool _categoryMatches(String bookCategory, String selectedCategory) {
    final category = bookCategory.toLowerCase();
    const aliases = <String, List<String>>{
      'رواية': ['fiction', 'novel', 'رواية'],
      'رومانسي': ['romance', 'romantic', 'رومانسي'],
      'غموض': ['mystery', 'thriller', 'غموض'],
      'فانتازيا': ['fantasy', 'فانتازيا'],
      'تطوير ذات': ['self-help', 'self help', 'تطوير ذات'],
      'تكنولوجيا': ['technology', 'computers', 'تكنولوجيا'],
    };
    if (selectedCategory == 'الكل') return true;
    final terms = aliases[selectedCategory] ?? [selectedCategory.toLowerCase()];
    return terms.any(category.contains);
  }

  // ===== Navigation =====
  void _openBookDetails(BookItem book) {
    context.push(AppRoutes.bookPath(book.id));
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

  Widget _booksSection(_BooksState state, VoidCallback onRetry) {
    if (state.isLoading) return _booksLoading();
    if (state.error != null) {
      return _booksMessage(state.error!, onRetry: onRetry);
    }
    if (state.items.isEmpty) {
      return _booksMessage(
        identical(state, recent)
            ? 'لسه مفيش كتب اتصفحت. افتح أي كتاب وهتلاقيه هنا.'
            : 'لا توجد كتب حالياً',
      );
    }

    final books = _filterBooks(state.items);
    if (books.isEmpty) {
      return _booksMessage('مفيش كتب مطابقة للفلاتر المختارة');
    }
    // عرض الرف = من أول كتاب لحد آخر كتاب بالظبط
    final shelfWidth =
        books.length * _bookWidth + (books.length - 1) * _bookGap;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BookCard يتولى تحميل الغلاف من الإنترنت أو assets تلقائياً.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < books.length; i++) ...[
                if (i != 0) const SizedBox(width: _bookGap),
                SizedBox(
                  width: _bookWidth,
                  child: BookCard(
                    title: books[i].title,
                    author: books[i].author,
                    coverAsset: books[i].image,
                    isFavorite: _isFavorite(books[i].id),
                    onTap: () => _openBookDetails(books[i]),
                    onFavoriteTap: () => _toggleFavorite(books[i]),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 8),
          // الرف (بيبدأ من أول كتاب وينتهي عند آخر كتاب)
          SizedBox(
            width: shelfWidth,
            height: 10,
            child: Image.asset('assets/images/roof2.png', fit: BoxFit.fill),
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
        int selectedReadingStatus = currentReadingStatus;

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
                              children: List.generate(types.length, (index) {
                                final isSelected = selectedType == index;
                                return ElevatedButton(
                                  onPressed: () {
                                    setSheetState(() {
                                      selectedType = index;
                                    });
                                  },
                                  style: filterButtonStyle(isSelected),
                                  child: Text(types[index]),
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
    // رف "آخر ما تصفحت" بيقرا من HistoryProvider، فبيتحدث لوحده
    // لما أي كتاب يتفتح (نفس مصدر شاشة "عرض الكل").
    final history = context.watch<HistoryProvider>();
    // بنتابع المفضلة عشان القلوب تتحدث لما تتغير
    context.watch<FavoritesProvider>();
    recent
      ..isLoading = !history.isInitialized
      ..error = null
      ..items = history.recentBooks.map(BookItem.fromBook).toList();

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
                            controller: _searchController,
                            onChanged: _onHomeSearchChanged,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: 'ابحث عن كتاب او مؤلف ...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      tooltip: 'مسح البحث',
                                      onPressed: () {
                                        _searchController.clear();
                                        _onHomeSearchChanged('');
                                      },
                                      icon: const Icon(Icons.close),
                                    )
                                  : null,
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
                            tooltip: 'فلترة الكتب',
                            icon: Icon(
                              currentIndex != 0 || currentReadingStatus != 0
                                  ? Icons.filter_alt
                                  : Icons.filter_list,
                            ),
                            color: Colors.black,
                            iconSize: 28,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_searchQuery.trim().isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 18, right: 18, left: 18),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'نتائج البحث',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    _homeSearchResultsSection(),
                    const SizedBox(height: 16),
                  ] else ...[
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

                    // مفيش إعادة محاولة هنا: السجل محلي بيتحدث لوحده
                    _booksSection(recent, () {}),

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
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}