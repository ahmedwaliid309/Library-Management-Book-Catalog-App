import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:raffi/data/models/book.dart';
import 'package:raffi/providers/library_provider.dart';

import 'package:raffi/features/library/library_widgets/empty_shelf.dart';
import 'package:raffi/features/library/library_widgets/library_book_card.dart';

class LibraryShelf extends StatelessWidget {
  const LibraryShelf({
    super.key,
    required this.title,
    required this.iconPath,
    required this.status,
    required this.books,
    required this.onAdd,
  });

  final String title;
  final String iconPath;
  final ReadingStatus status;
  final List<Book> books;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DragTarget<Book>(
      onWillAcceptWithDetails: (details) {
        return details.data.id.isNotEmpty;
      },
      onAcceptWithDetails: (details) async {
        final book = details.data;

        await context.read<LibraryProvider>().updateStatus(
          book.id,
          status,
        );
      },
      builder: (context, candidateData, _) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 270,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.onPrimary,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isHovering
                  ? colors.primary
                  : colors.outlineVariant,
              width: isHovering ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // Shelf Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colors.primary,
                        ),
                      ),
                      child: ImageIcon(
                        AssetImage(iconPath),
                        color: colors.primary,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Number of books
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${books.length}',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Add book
                    InkWell(
                      onTap: onAdd,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colors.primary,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 1,
                color: colors.outlineVariant,
              ),

              // Shelf Books
              Expanded(
                child: books.isEmpty
                    ? const EmptyShelf()
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];

                    return LibraryBookCard(
                      book: book,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}