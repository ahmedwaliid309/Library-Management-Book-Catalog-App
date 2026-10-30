import 'package:flutter/material.dart';
import 'package:raffi/data/models/book.dart';
import 'package:raffi/features/library/bottom_sheet_widgets//book_cover.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({
    super.key,
    required this.book,
    required this.isSelected,
    required this.onTap,
  });

  final Book book;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? colors.primaryContainer : colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BookCover(
                  book: book,
                  width: 65,
                  height: 85,
                ),
              ),

              const SizedBox(width: 12),

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
  }
}