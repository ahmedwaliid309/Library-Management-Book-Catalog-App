import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffi/providers/history_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:raffi/data/book_repository.dart';
import 'package:raffi/data/models/book.dart';
import 'package:raffi/providers/library_provider.dart';

class BottomSheetScreen extends StatefulWidget {
  const BottomSheetScreen({
    super.key,
    this.initialStatus = ReadingStatus.wantToRead,
  });

  final ReadingStatus initialStatus;

  @override
  State<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  static const String _recentBooksKey = 'recently_viewed_books';

  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  List<Book> _suggestedBooks = [];
  List<Book> _recentBooks = [];

  int _selectedTabIndex = 0;

  Book? _selectedBook;
  late ReadingStatus _selectedStatus;

  bool _isLoading = false;
  bool _hasSearched = false;
  bool _isSaving = false;
  bool _isLoadingInitialBooks = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _selectedStatus = widget.initialStatus;

    _loadInitialBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =========================================================
  // Load suggestions and recently viewed books
  // =========================================================

  Future<void> _loadInitialBooks() async {
    await Future.wait([
      _loadSuggestions(),
      _loadRecentlyViewedBooks(),
    ]);

    if (!mounted) return;

    setState(() {
      _isLoadingInitialBooks = false;
    });
  }

  Future<void> _loadSuggestions() async {
    try {
      final repository = context.read<BookRepository>();

      final books = await repository.search(
        'programming',
        pageSize: 10,
      );

      if (!mounted) return;

      setState(() {
        _suggestedBooks = books;
      });
    } catch (e) {
      debugPrint('Failed to load suggested books: $e');
    }
  }

  Future<void> _loadRecentlyViewedBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedBooks = prefs.getString(_recentBooksKey);

      if (savedBooks == null) return;

      final decoded = jsonDecode(savedBooks) as List<dynamic>;

      final books = decoded
          .map(
            (item) => Book.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList();

      if (!mounted) return;

      setState(() {
        _recentBooks = books;
      });
    } catch (e) {
      debugPrint('Failed to load recently viewed books: $e');
    }
  }

  // =========================================================
  // Save a book when its details page is opened
  // =========================================================

  static Future<void> recordViewedBook(Book book) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedBooks = prefs.getString(_recentBooksKey);

      List<Book> recentBooks = [];

      if (savedBooks != null) {
        final decoded = jsonDecode(savedBooks) as List<dynamic>;

        recentBooks = decoded
            .map(
              (item) => Book.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
            .toList();
      }

      // Remove duplicates so the latest visit moves to the front.
      recentBooks.removeWhere(
            (existingBook) => existingBook.id == book.id,
      );

      recentBooks.insert(0, book);

      // Keep the last 10 viewed books.
      if (recentBooks.length > 10) {
        recentBooks = recentBooks.take(10).toList();
      }

      final encodedBooks = recentBooks
          .map((item) => item.toJson())
          .toList();

      await prefs.setString(
        _recentBooksKey,
        jsonEncode(encodedBooks),
      );
    } catch (e) {
      debugPrint('Failed to save recently viewed book: $e');
    }
  }

  // =========================================================
  // Search
  // =========================================================

  Future<void> _searchBooks(String query) async {
    final searchQuery = query.trim();

    if (searchQuery.isEmpty) {
      setState(() {
        _searchResults = [];
        _selectedBook = null;
        _hasSearched = false;
        _errorMessage = null;
        _isLoading = false;
      });

      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
      _selectedBook = null;
    });

    try {
      final repository = context.read<BookRepository>();

      final results = await repository.search(searchQuery);

      if (!mounted) return;

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _searchResults = [];
        _isLoading = false;
        _errorMessage = 'حدث خطأ أثناء البحث عن الكتب';
      });
    }
  }

  // =========================================================
  // Select book
  // =========================================================

  void _selectBook(Book book) {
    setState(() {
      _selectedBook = book;
    });
  }

  // =========================================================
  // Add selected book to library
  // =========================================================

  Future<void> _addSelectedBook() async {
    if (_selectedBook == null) {
      _showMessage('من فضلك اختار كتاب الأول');
      return;
    }

    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final library = context.read<LibraryProvider>();

      final added = await library.addBook(
        _selectedBook!,
        status: _selectedStatus,
      );

      if (!mounted) return;

      if (!added) {
        setState(() {
          _isSaving = false;
        });

        _showMessage('الكتاب موجود بالفعل في مكتبتك');
        return;
      }

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      _showMessage('تعذرت إضافة الكتاب، حاول مرة أخرى');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // =========================================================
  // Reading status
  // =========================================================

  String _statusLabel(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.wantToRead:
        return 'أريد قراءته';

      case ReadingStatus.currentlyReading:
        return 'أقرأ حاليًا';

      case ReadingStatus.completed:
        return 'مكتمل';
    }
  }

  Widget _buildStatusButton(ReadingStatus status) {
    final isSelected = _selectedStatus == status;
    final colors = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(
        _statusLabel(status),
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? colors.onPrimary : colors.onSurface,
        ),
      ),
      selected: isSelected,
      selectedColor: colors.primary,
      backgroundColor: colors.surfaceContainerHighest,
      showCheckmark: false,
      onSelected: (selected) {
        if (!selected) return;

        setState(() {
          _selectedStatus = status;
        });
      },
    );
  }

  // =========================================================
  // Book cover
  // =========================================================

  Widget _buildBookCover(
      Book book, {
        double width = 50,
        double height = 65,
      }) {
    final cover = book.coverAsset;

    if (cover.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: const Icon(
          Icons.book_outlined,
          size: 35,
        ),
      );
    }

    if (cover.startsWith('http://') ||
        cover.startsWith('https://')) {
      return Image.network(
        cover,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return SizedBox(
            width: width,
            height: height,
            child: const Icon(Icons.book_outlined, size: 35),
          );
        },
      );
    }

    return Image.asset(
      cover,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return SizedBox(
          width: width,
          height: height,
          child: const Icon(Icons.book_outlined, size: 35),
        );
      },
    );
  }

  // =========================================================
  // Suggested books
  // =========================================================

  // =========================================================
// Suggested books - Vertical List
// =========================================================

  Widget _buildSuggestedBooks() {
    if (_isLoadingInitialBooks && _suggestedBooks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_suggestedBooks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'لا توجد اقتراحات متاحة حاليًا',
            style: TextStyle(fontSize: 12),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _suggestedBooks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final book = _suggestedBooks[index];
        final isSelected = _selectedBook?.id == book.id;
        final colors = Theme.of(context).colorScheme;

        return Material(
          color: isSelected
              ? colors.primaryContainer
              : colors.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _selectBook(book),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? colors.primary
                      : colors.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  // Book cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildBookCover(
                      book,
                      width: 65,
                      height: 85,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Book information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title.isEmpty
                              ? 'كتاب بدون عنوان'
                              : book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          book.author.isEmpty
                              ? 'مؤلف غير معروف'
                              : book.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Selection indicator
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.add_circle_outline,
                    color: isSelected ? colors.primary : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // Recently viewed books
  // =========================================================

// =========================================================
// Recently viewed books - Vertical List
// =========================================================

  Widget _buildRecentlyViewedBooks() {
    final historyProvider = context.watch<HistoryProvider>();
    final recentBooks = historyProvider.recentBooks;
    final isLoading = !historyProvider.isInitialized;

    if (isLoading && recentBooks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (recentBooks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'الكتب التي تتصفحها ستظهر هنا',
            style: TextStyle(fontSize: 12),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentBooks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final book = recentBooks[index];
        final isSelected = _selectedBook?.id == book.id;
        final colors = Theme.of(context).colorScheme;

        return Material(
          color: isSelected
              ? colors.primaryContainer
              : colors.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _selectBook(book),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? colors.primary
                      : colors.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  // Book cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildBookCover(
                      book,
                      width: 65,
                      height: 85,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Book information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title.isEmpty
                              ? 'كتاب بدون عنوان'
                              : book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          book.author.isEmpty
                              ? 'مؤلف غير معروف'
                              : book.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Selection indicator
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.add_circle_outline,
                    color: isSelected ? colors.primary : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// =========================================================
// Content tabs
// =========================================================

  Widget _buildContentTabs() {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildTabButton(
            title: 'اقتراحات لك',
            index: 0,
            colors: colors,
          ),
        ),
        Expanded(
          child: _buildTabButton(
            title: 'آخر ما تصفحت',
            index: 1,
            colors: colors,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String title,
    required int index,
    required ColorScheme colors,
  }) {
    final isSelected = _selectedTabIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? colors.primary
                  : colors.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight:
              isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? colors.primary
                  : colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

// =========================================================
// Selected tab content
// =========================================================

  Widget _buildInitialContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContentTabs(),

        const SizedBox(height: 12),

        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            child: _selectedTabIndex == 0
                ? _buildSuggestedBooks()
                : _buildRecentlyViewedBooks(),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // Search results
  // =========================================================

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!),
      );
    }

    if (!_hasSearched) {
      return _buildInitialContent();
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('لم يتم العثور على كتب'),
      );
    }

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final book = _searchResults[index];

        final isSelected = _selectedBook?.id == book.id;

        return Material(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: _buildBookCover(book),
            ),
            title: Text(
              book.title.isEmpty ? 'كتاب بدون عنوان' : book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              book.author.isEmpty ? 'مؤلف غير معروف' : book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.add_circle_outline,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onTap: () => _selectBook(book),
          ),
        );
      },
    );
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: 600 + bottomInset,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + bottomInset,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - unchanged
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أضف كتاب لمكتبتي',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اختر الكتاب والرف المناسب',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: colors.surfaceContainerHighest,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Search field - unchanged
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: _searchBooks,
            decoration: InputDecoration(
              hintText: 'ابحث عن كتاب',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchBooks(_searchController.text);
                },
                icon: const Icon(Icons.arrow_forward),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: colors.onPrimary,
            ),
          ),

          const SizedBox(height: 12),

          // Suggestions, recent books, or search results
          // Suggestions tabs or search results
          Expanded(
            child: _hasSearched
                ? _buildSearchResults()
                : _buildInitialContent(),
          ),

          const SizedBox(height: 12),

          // Reading status - unchanged
          Text(
            'أضفه إلى رف',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _buildStatusButton(ReadingStatus.wantToRead),
              _buildStatusButton(ReadingStatus.currentlyReading),
              _buildStatusButton(ReadingStatus.completed),
            ],
          ),

          const SizedBox(height: 12),

          // Action buttons - unchanged
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.primary),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _addSelectedBook,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Center(
                    child: Text(
                      'إضافة إلى المكتبة',
                      style: TextStyle(
                        fontSize: 12,
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
    );
  }
}