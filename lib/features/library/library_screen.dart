import 'package:flutter/material.dart';
import 'package:raffi/features/library/bottom_sheet_screen.dart';
import 'package:raffi/features/library/lib_utils.dart';

import '../../core/widgets/placeholder_screen.dart';

// المسؤول: أحمد عطا (مكتبتي + Sheet إضافة كتاب)
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<String> books = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مكتبتي",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          "مكتبتك الشخصية",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (context) {
                            return BottomSheetScreen();
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 105,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "إضافة كتاب",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 8,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary,
                                  ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  AssetImage("assets/images/ic_books.png"),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "اضغط مطولا واسحب الكتاب بين الرفوف,",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          LibUtils(imagePath: "assets/images/ic_saved_book.png", text: "أريد قراءته",onActionTap: (){},),
                          SizedBox(height: 20),
                          LibUtils(imagePath: "assets/images/ic_book_read.png", text: "أقرأ حاليا",onActionTap: (){},),
                          SizedBox(height: 20),
                          LibUtils(imagePath: "assets/images/ic_complete.png", text: "مكتمل",onActionTap: (){},),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
