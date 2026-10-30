import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/book_search_field.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/book_search_results.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/bottom_sheet_actions.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/bottom_sheet_header.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/library_content_tabs.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/reading_status_selector.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/recently_viewed_books_list.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/suggested_books_list.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  List<Book> _suggestedBooks = [];

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
    await _loadSuggestions();

    if (!mounted) return;

    setState(() {
      _isLoadingInitialBooks = false;
    });
  }

  Future<void> _loadSuggestions() async {
    try {
      final repository = context.read<BookRepository>();

      final books = await repository.search('programming', pageSize: 10);

      if (!mounted) return;

      setState(() {
        _suggestedBooks = books;
      });
    } catch (e) {
      debugPrint('Failed to load suggested books: $e');
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // =========================================================
  // Selected tab content
  // =========================================================

  Widget _buildInitialContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LibraryContentTabs(
          selectedIndex: _selectedTabIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
        ),

        const SizedBox(height: 12),

        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: _selectedTabIndex == 0
                ? SuggestedBooksList(
                    books: _suggestedBooks,
                    isLoading: _isLoadingInitialBooks,
                    selectedBookId: _selectedBook?.id,
                    onBookSelected: _selectBook,
                  )
                : RecentlyViewedBooksList(
                    selectedBookId: _selectedBook?.id,
                    onBookSelected: _selectBook,
                  ),
          ),
        ),
      ],
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
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - unchanged
          BottomSheetHeader(onClose: () => Navigator.pop(context)),

          const SizedBox(height: 16),

          // Search field - unchanged
          BookSearchField(
            controller: _searchController,
            onSearch: _searchBooks,
          ),

          const SizedBox(height: 12),
          // Suggestions tabs or search results
          Expanded(
            child: _hasSearched
                ? BookSearchResults(
                    books: _searchResults,
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                    selectedBookId: _selectedBook?.id,
                    onBookSelected: _selectBook,
                  )
                : _buildInitialContent(),
          ),

          const SizedBox(height: 12),

          // Reading status - unchanged
          ReadingStatusSelector(
            selectedStatus: _selectedStatus,
            onStatusChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
            },
          ),
          // Action buttons - unchanged
          BottomSheetActions(
            isSaving: _isSaving,
            onCancel: () => Navigator.pop(context),
            onAdd: _addSelectedBook,
          ),
        ],
      ),
    );
  }
}
