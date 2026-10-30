import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffi/features/library/bottom_sheet_widgets/bottom_sheet_screen.dart';
import 'package:raffi/features/library/library_widgets/library_header.dart';
import 'package:raffi/features/library/library_widgets/library_instruction_banner.dart';
import 'package:raffi/features/library/library_widgets/library_shelf.dart';
import 'package:raffi/providers/library_provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  void _openAddBookSheet(BuildContext context, ReadingStatus status) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => BottomSheetScreen(initialStatus: status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LibraryHeader(
              onAddBook: () {
        _openAddBookSheet(
        context,
        ReadingStatus.wantToRead,
        );
        },
        ),

              const SizedBox(height: 20),

              // Library content
              Expanded(
                child: Consumer<LibraryProvider>(
                  builder: (context, library, child) {
                    if (!library.isInitialized) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          LibraryInstructionBanner(),
                          const SizedBox(height: 20),

                          // Want to read
                          LibraryShelf(
                            title: 'أريد قراءته',
                            iconPath: 'assets/images/ic_saved_book.png',
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
                          LibraryShelf(
                            title: 'أقرأ حاليًا',
                            iconPath: 'assets/images/ic_book_read.png',
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
                          LibraryShelf(
                            title: 'مكتمل',
                            iconPath: 'assets/images/ic_complete.png',
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
