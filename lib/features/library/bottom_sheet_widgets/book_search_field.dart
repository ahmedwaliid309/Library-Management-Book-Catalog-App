import 'package:flutter/material.dart';

class BookSearchField extends StatelessWidget {
  const BookSearchField({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSearch,
      decoration: InputDecoration(
        hintText: 'ابحث عن كتاب',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () {
            onSearch(controller.text);
          },
          icon: const Icon(Icons.arrow_forward),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: colors.onPrimary,
      ),
    );
  }
}