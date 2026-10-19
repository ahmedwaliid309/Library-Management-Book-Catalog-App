import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:raffi/data/models/book.dart';
import 'package:raffi/features/library/bottom_sheet_screen.dart';
import 'package:raffi/providers/library_provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  void _openAddBookSheet(
      BuildContext context,
      ReadingStatus status,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) => BottomSheetScreen(
        initialStatus: status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مكتبتي',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'مكتبتك الشخصية',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),

                  ElevatedButton.icon(
                    onPressed: () {
                      _openAddBookSheet(
                        context,
                        ReadingStatus.wantToRead,
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'إضافة كتاب',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      minimumSize: const Size(110, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Library content
              Expanded(
                child: Consumer<LibraryProvider>(
                  builder: (context, library, child) {
                    if (!library.isInitialized) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Instruction
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.swap_horiz,
                                  color: colors.onPrimaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'اضغط مطولًا واسحب الكتاب بين الرفوف',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Want to read
                          _LibraryShelf(
                            title: 'أريد قراءته',
                            iconPath:
                            'assets/images/ic_saved_book.png',
                            status: ReadingStatus.wantToRead,
                            books: library.booksByStatus(
                              ReadingStatus.wantToRead,
                            ),
                            onAdd: () {
                              _openAddBookSheet(
                                context,
                                ReadingStatus.wantToRead,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // Currently reading
                          _LibraryShelf(
                            title: 'أقرأ حاليًا',
                            iconPath:
                            'assets/images/ic_book_read.png',
                            status: ReadingStatus.currentlyReading,
                            books: library.booksByStatus(
                              ReadingStatus.currentlyReading,
                            ),
                            onAdd: () {
                              _openAddBookSheet(
                                context,
                                ReadingStatus.currentlyReading,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // Completed
                          _LibraryShelf(
                            title: 'مكتمل',
                            iconPath:
                            'assets/images/ic_complete.png',
                            status: ReadingStatus.completed,
                            books: library.booksByStatus(
                              ReadingStatus.completed,
                            ),
                            onAdd: () {
                              _openAddBookSheet(
                                context,
                                ReadingStatus.completed,
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Library Shelf
// ============================================================

class _LibraryShelf extends StatelessWidget {
  const _LibraryShelf({
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
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 270,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isHovering
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onPrimary,
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
              // Shelf header
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

              // Shelf books
              Expanded(
                child: books.isEmpty
                    ? _EmptyShelf()
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];

                    return _BookCard(
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

// ============================================================
// Book Card
// ============================================================

class _BookCard extends StatelessWidget {
  const _BookCard({
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
          child: _buildBookCard(colors),
        ),
        child: _buildBookCard(colors),
      ),
    );
  }

  Widget _buildBookCard(ColorScheme colors) {
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
                  child: Builder(
                    builder: (context) {
                      return Material(
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
                      );
                    },
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
            book.author.isEmpty ? 'مؤلف غير معروف' : book.author,
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

// ============================================================
// Empty Shelf
// ============================================================

class _EmptyShelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/images/ic_books.png'),
              size: 35,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'لا توجد كتب في هذا الرف',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Book Cover Placeholder
// ============================================================

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

