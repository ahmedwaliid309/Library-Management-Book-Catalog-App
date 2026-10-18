import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Book? _selectedBook;

  late ReadingStatus _selectedStatus;

  bool _isLoading = false;
  bool _hasSearched = false;
  bool _isSaving = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchBooks(String query) async {
    final searchQuery = query.trim();

    if (searchQuery.isEmpty) {
      setState(() {
        _searchResults = [];
        _selectedBook = null;
        _hasSearched = false;
        _errorMessage = null;
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

  Widget _buildBookCover(Book book) {
    final cover = book.coverAsset;

    if (cover.isEmpty) {
      return const SizedBox(
        width: 50,
        height: 65,
        child: Icon(Icons.book_outlined, size: 35),
      );
    }

    if (cover.startsWith('http://') || cover.startsWith('https://')) {
      return Image.network(
        cover,
        width: 50,
        height: 65,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const SizedBox(
            width: 50,
            height: 65,
            child: Icon(Icons.book_outlined, size: 35),
          );
        },
      );
    }

    return Image.asset(
      cover,
      width: 50,
      height: 65,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return const SizedBox(
          width: 50,
          height: 65,
          child: Icon(Icons.book_outlined, size: 35),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (!_hasSearched) {
      return const Center(
        child: Text(
          'ابحث عن كتاب لإضافته إلى مكتبتك',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(child: Text('لم يتم العثور على كتب'));
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
              isSelected ? Icons.check_circle : Icons.add_circle_outline,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
            onTap: () {
              setState(() {
                _selectedBook = book;
              });
            },
          ),
        );
      },
    );
  }

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أضف كتاب لمكتبتي',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اختر الكتاب والرف المناسب',
                      style: Theme.of(context).textTheme.bodyMedium
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

          // Search field
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
              fillColor: colors.surfaceContainerHighest,
            ),
          ),

          const SizedBox(height: 12),

          // Search results
          Expanded(child: _buildSearchResults()),

          const SizedBox(height: 12),

          Text(
            'أضفه إلى رف',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // Reading status
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

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('إلغاء', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary)),
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
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      :  Center(
                        child: Text(
                            'إضافة إلى المكتبة',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
