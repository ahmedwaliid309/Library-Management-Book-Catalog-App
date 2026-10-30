import 'package:flutter/material.dart';

class LibraryContentTabs extends StatelessWidget {
  const LibraryContentTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildTabButton(
            title: 'اقتراحات لك',
            index: 0,
            colors: colors,
          ),
        ),
        Expanded(
          child: _buildTabButton(
            title: 'آخر ما تصفحت',
            index: 1,
            colors: colors,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String title,
    required int index,
    required ColorScheme colors,
  }) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? colors.primary
                  : colors.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isSelected
                  ? colors.primary
                  : colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}