import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raffi/data/models/book.dart';

enum ReadingStatus { wantToRead, currentlyReading, completed }

class LibraryProvider extends ChangeNotifier {
  static const String _storageKey = 'user_library';

  final Map<String, Book> _books = {};
  final Map<String, ReadingStatus> _statuses = {};

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  List<Book> get allBooks => List.unmodifiable(_books.values);

  List<Book> booksByStatus(ReadingStatus status) {
    return _books.values.where((book) => _statuses[book.id] == status).toList();
  }

  ReadingStatus? statusOf(String bookId) => _statuses[bookId];

  bool contains(String bookId) => _books.containsKey(bookId);

  Future<void> loadLibrary() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString(_storageKey);

    if (storedData != null) {
      try {
        final decoded = jsonDecode(storedData) as List<dynamic>;

        for (final item in decoded) {
          final data = item as Map<String, dynamic>;
          final book = Book.fromJson(data);

          final statusName = data['readingStatus'] as String?;

          final status = ReadingStatus.values.firstWhere(
            (value) => value.name == statusName,
            orElse: () => ReadingStatus.wantToRead,
          );

          _books[book.id] = book;
          _statuses[book.id] = status;
        }
      } catch (e) {
        debugPrint('Failed to load library: $e');
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> addBook(
    Book book, {
    ReadingStatus status = ReadingStatus.wantToRead,
  }) async {
    if (_books.containsKey(book.id)) {
      return false;
    }

    _books[book.id] = book;
    _statuses[book.id] = status;

    await _saveLibrary();
    notifyListeners();

    return true;
  }

  Future<void> removeBook(String bookId) async {
    _books.remove(bookId);
    _statuses.remove(bookId);

    await _saveLibrary();
    notifyListeners();
  }

  Future<void> updateStatus(String bookId, ReadingStatus status) async {
    if (!_books.containsKey(bookId)) return;

    _statuses[bookId] = status;

    await _saveLibrary();
    notifyListeners();
  }

  Future<void> _saveLibrary() async {
    final prefs = await SharedPreferences.getInstance();

    final data = _books.values.map((book) {
      return {...book.toJson(), 'readingStatus': _statuses[book.id]!.name};
    }).toList();

    await prefs.setString(_storageKey, jsonEncode(data));
  }
}
