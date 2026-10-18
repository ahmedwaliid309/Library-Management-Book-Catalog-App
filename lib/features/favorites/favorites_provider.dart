import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:raffi/data/models/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// المفضلة (بتتخزن على الجهاز).
class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider() {
    _loadFuture = load();
  }

  static const _key = 'favorite_books';

  late final Future<void> _loadFuture;

  final List<Book> _items = [];
  bool _loaded = false;

  List<Book> get items => List.unmodifiable(_items);
  bool get isLoaded => _loaded;

  bool isFavorite(String id) => _items.any((b) => b.id == id);

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);

      if (raw != null) {
        final list = jsonDecode(raw) as List;

        _items
          ..clear()
          ..addAll(
            list.map(
                  (e) => Book.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            ),
          );
      }
    } catch (e) {
      debugPrint('FavoritesProvider.load failed: $e');
    } finally {
      _loaded = true;
      notifyListeners();
    }
  }

  Future<void> toggle(Book book) async {
    await _loadFuture;

    final i = _items.indexWhere((b) => b.id == book.id);

    if (i >= 0) {
      _items.removeAt(i);
    } else {
      _items.insert(0, book);
    }

    notifyListeners();

    await _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        _key,
        jsonEncode(_items.map((b) => b.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('FavoritesProvider.save failed: $e');
    }
  }
}