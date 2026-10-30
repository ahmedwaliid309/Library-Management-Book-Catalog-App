import 'package:flutter/material.dart';

import 'package:raffi/data/models/book.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/book_cover.dart';

class BookSearchResults extends StatelessWidget {
  const BookSearchResults({
    super.key,
    required this.books,
    required this.isLoading,
    required this.errorMessage,
    required this.selectedBookId,
    required this.onBookSelected,
  });

  final List<Book> books;
  final bool isLoading;
  final String? errorMessage;
  final String? selectedBookId;
  final ValueChanged<Book> onBookSelected;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!),
      );
    }

    if (books.isEmpty) {
      return const Center(
        child: Text('لم يتم العثور على كتب'),
      );
    }

    final colors = Theme.of(context).colorScheme;

    return ListView.separated(
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final book = books[index];
        final isSelected = selectedBookId == book.id;

        return Material(
          color: isSelected
              ? colors.primaryContainer
              : colors.surface,
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: BookCover(book: book),
            ),
            title: Text(
              book.title.isEmpty
                  ? 'كتاب بدون عنوان'
                  : book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              book.author.isEmpty
                  ? 'مؤلف غير معروف'
                  : book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.add_circle_outline,
              color: isSelected ? colors.primary : null,
            ),
            onTap: () => onBookSelected(book),
          ),
        );
      },
    );
  }
}