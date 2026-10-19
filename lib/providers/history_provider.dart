import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raffi/data/models/book.dart';

class HistoryProvider extends ChangeNotifier {
  static const String _storageKey = 'reading_history';
  static const int _maxHistoryItems = 20;

  final List<Book> _recentBooks = [];
  bool _isInitialized = false;

  // هنا بنوفر للواجهة أحدث الكتب، من غير السماح بتعديل القائمة الأصلية.
  List<Book> get recentBooks => List.unmodifiable(_recentBooks);

  bool get isInitialized => _isInitialized;

  // هنا بنحمّل سجل التصفح المحفوظ على الجهاز مرة واحدة.
  Future<void> loadHistory() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString(_storageKey);

    if (storedData != null) {
      try {
        final decoded = jsonDecode(storedData);

        if (decoded is List) {
          for (final item in decoded) {
            if (item is! Map) continue;

            try {
              final book = Book.fromJson(
                Map<String, dynamic>.from(item),
              );

              if (book.id.isEmpty) continue;

              // منع تكرار نفس الكتاب أثناء استرجاع البيانات.
              _recentBooks.removeWhere(
                (existingBook) => existingBook.id == book.id,
              );
              _recentBooks.add(book);
            } catch (e) {
              debugPrint('Failed to load a history item: $e');
            }
          }
        }
      } catch (e) {
        debugPrint('Failed to load reading history: $e');
      }
    }

    // ترتيب القائمة المحفوظة من الأحدث للأقدم.
    if (_recentBooks.length > _maxHistoryItems) {
      _recentBooks.removeRange(_maxHistoryItems, _recentBooks.length);
    }

    _isInitialized = true;
    notifyListeners();
  }

  // هنا بنضيف الكتاب في أول السجل، أو ننقله للأول لو اتفتح قبل كده.
  Future<void> recordViewedBook(Book book) async {
    if (book.id.isEmpty) return;

    // هنا بنحمّل السجل القديم قبل ما نحفظ أي كتاب جديد.
    await loadHistory();

    _recentBooks.removeWhere(
      (existingBook) => existingBook.id == book.id,
    );
    _recentBooks.insert(0, book);

    // بنحتفظ بآخر 20 كتاب فقط.
    if (_recentBooks.length > _maxHistoryItems) {
      _recentBooks.removeRange(_maxHistoryItems, _recentBooks.length);
    }

    await _saveHistory();
    notifyListeners();
  }

  // هنا بنمسح سجل التصفح المحفوظ محليًا.
  Future<void> clearHistory() async {
    _recentBooks.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);

    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _recentBooks.map((book) => book.toJson()).toList();

    await prefs.setString(_storageKey, jsonEncode(data));
  }
}
