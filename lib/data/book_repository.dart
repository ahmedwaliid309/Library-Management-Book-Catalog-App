import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:raffi/core/config/app_config.dart';

import 'mock_books.dart';
import 'models/book.dart';

class BookRepository {
  static const _base = 'https://www.googleapis.com/books/v1/volumes';
  final Map<String, List<Book>> _cache = {};

  Future<List<Book>> search(
    String query, {
    int page = 0,
    int pageSize = 20,
  }) async {
    final key = '$query|$page';
    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final uri = Uri.parse(_base).replace(queryParameters: {
        'q': query,
        'langRestrict': 'ar',
        'printType': 'books',
        'startIndex': '${page * pageSize}',
        'maxResults': '$pageSize',
        if (AppConfig.hasApiKey) 'key': AppConfig.booksApiKey,
      });
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final items = (data['items'] as List?) ?? const [];
      final books = items
          .map((e) => Book.fromGoogle(e as Map<String, dynamic>))
          .toList();
      _cache[key] = books;
      return books;
    } catch (e) {
      // لو الـ API وقع أو مفيش نت، نرجع للداتا التجريبية
      debugPrint('BookRepository.search failed: $e');
      return MockBooks.all
          .where((b) => b.title.contains(query) || b.author.contains(query))
          .toList();
    }
  }

  Future<List<Book>> byCategory(String category, {int page = 0}) =>
      search('subject:$category', page: page);

  Future<Book?> details(String id) async {
    try {
      final uri = Uri.parse('$_base/$id').replace(queryParameters: {
        if (AppConfig.hasApiKey) 'key': AppConfig.booksApiKey,
      });
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
      return Book.fromGoogle(jsonDecode(res.body) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('BookRepository.details failed: $e');
      return MockBooks.byId(id);
    }
  }
}