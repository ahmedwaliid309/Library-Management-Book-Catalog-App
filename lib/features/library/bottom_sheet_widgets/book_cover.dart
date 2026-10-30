import 'package:flutter/material.dart';
import 'package:raffi/data/models/book.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.book,
    this.width = 50,
    this.height = 65,
  });

  final Book book;
  final double width;
  final double height;

  Widget _buildPlaceholder() {
    return SizedBox(
      width: width,
      height: height,
      child: const Icon(
        Icons.book_outlined,
        size: 35,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cover = book.coverAsset;

    if (cover.isEmpty) {
      return _buildPlaceholder();
    }

    if (cover.startsWith('http://') ||
        cover.startsWith('https://')) {
      return Image.network(
        cover,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _buildPlaceholder();
        },
      );
    }

    return Image.asset(
      cover,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _buildPlaceholder();
      },
    );
  }
}