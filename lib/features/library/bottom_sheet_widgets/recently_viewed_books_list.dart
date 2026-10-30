import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:raffi/providers/history_provider.dart';
import 'package:raffi/data/models/book.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/book_list_item.dart';

class RecentlyViewedBooksList extends StatelessWidget {
  const RecentlyViewedBooksList({
    super.key,
    required this.selectedBookId,
    required this.onBookSelected,
  });

  final String? selectedBookId;
  final ValueChanged<Book> onBookSelected;

  @override
  Widget build(BuildContext context) {
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

        return BookListItem(
          book: book,
          isSelected: selectedBookId == book.id,
          onTap: () => onBookSelected(book),
        );
      },
    );
  }
}