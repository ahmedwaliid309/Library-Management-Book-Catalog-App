import 'package:flutter/material.dart';
import 'package:raffi/data/models/book.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/book_list_item.dart';

class SuggestedBooksList extends StatelessWidget {
  const SuggestedBooksList({
    super.key,
    required this.books,
    required this.isLoading,
    required this.selectedBookId,
    required this.onBookSelected,
  });

  final List<Book> books;
  final bool isLoading;
  final String? selectedBookId;
  final ValueChanged<Book> onBookSelected;

  @override
  Widget build(BuildContext context) {
    if (isLoading && books.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (books.isEmpty) {
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
      itemCount: books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final book = books[index];

        return BookListItem(
          book: book,
          isSelected: selectedBookId == book.id,
          onTap: () => onBookSelected(book),
        );
      },
    );
  }
}