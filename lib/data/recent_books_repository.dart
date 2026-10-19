import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/book.dart';

/// حفظ سجل الكتب التي فتح المستخدم تفاصيلها على الجهاز.
class RecentBooksRepository {
  static const String _storageKey = 'raffi_recent_books_v1';
  static const int _maxBooks = 12;

  /// تنبيه شاشة الرئيسية لتحديث الرف فور تسجيل كتاب جديد.
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  Future<List<Book>> getRecentBooks() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedItems = preferences.getStringList(_storageKey) ?? const <String>[];
      final books = <Book>[];

      for (final item in savedItems) {
        try {
          final decoded = jsonDecode(item);
          if (decoded is Map<String, dynamic>) {
            books.add(Book.fromJson(decoded));
          } else if (decoded is Map) {
            books.add(Book.fromJson(Map<String, dynamic>.from(decoded)));
          }
        } catch (_) {
          // تجاهل أي عنصر تالف مع الاحتفاظ بباقي السجل.
        }
      }

      return books;
    } catch (_) {
      return <Book>[];
    }
  }

  /// يضع أحدث كتاب في البداية ويحذف التكرار ويحفظ آخر 12 كتاباً.
  Future<void> addBook(Book book) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedItems = preferences.getStringList(_storageKey) ?? const <String>[];
      final books = <Book>[];

      for (final item in savedItems) {
        try {
          final decoded = jsonDecode(item);
          if (decoded is Map<String, dynamic>) {
            books.add(Book.fromJson(decoded));
          } else if (decoded is Map) {
            books.add(Book.fromJson(Map<String, dynamic>.from(decoded)));
          }
        } catch (_) {
          // تجاهل العنصر التالف.
        }
      }

      books.removeWhere((savedBook) => savedBook.id == book.id);
      books.insert(0, book);

      final limitedBooks = books.take(_maxBooks);
      await preferences.setStringList(
        _storageKey,
        limitedBooks.map((savedBook) => jsonEncode(savedBook.toJson())).toList(),
      );
      changes.value++;
    } catch (_) {
      // فشل الحفظ المحلي لا ينبغي أن يمنع فتح تفاصيل الكتاب.
    }
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }
}
