import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:raffi/data/models/book.dart';
import 'package:raffi/providers/library_provider.dart';

class LibraryBookCard extends StatelessWidget {
  const LibraryBookCard({
    super.key,
    required this.book,
  });

  final Book book;

  Widget _buildCover() {
    if (book.coverAsset.isEmpty) {
      return const _BookCoverPlaceholder();
    }

    if (book.coverAsset.startsWith('http://') ||
        book.coverAsset.startsWith('https://')) {
      return Image.network(
        book.coverAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const _BookCoverPlaceholder();
        },
      );
    }

    return Image.asset(
      book.coverAsset,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const _BookCoverPlaceholder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: Draggable<Book>(
        data: book,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 115,
            height: 165,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildCover(),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _buildBookCard(context, colors),
        ),
        child: _buildBookCard(context, colors),
      ),
    );
  }

  Widget _buildBookCard(
      BuildContext context,
      ColorScheme colors,
      ) {
    return SizedBox(
      width: 115,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildCover(),
                ),

                // Remove book
                PositionedDirectional(
                  top: 4,
                  end: 4,
                  child: Material(
                    color: colors.surface.withValues(alpha: 0.9),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('حذف الكتاب'),
                              content: Text(
                                'هل تريد حذف "${book.title}" من مكتبتك؟',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                  },
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await context
                                        .read<LibraryProvider>()
                                        .removeBook(book.id);

                                    if (dialogContext.mounted) {
                                      Navigator.pop(dialogContext);
                                    }
                                  },
                                  child: const Text('حذف'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: colors.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            book.author.isEmpty
                ? 'مؤلف غير معروف'
                : book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Book cover placeholder

class _BookCoverPlaceholder extends StatelessWidget {
  const _BookCoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.primaryContainer,
      child: Icon(
        Icons.menu_book,
        size: 40,
        color: colors.primary,
      ),
    );
  }
}