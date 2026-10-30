import 'package:flutter/material.dart';

class EmptyShelf extends StatelessWidget {
  const EmptyShelf({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/images/ic_books.png'),
              size: 35,
              color: colors.onSurfaceVariant,
            ),

            const SizedBox(height: 8),

            Text(
              'لا توجد كتب في هذا الرف',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}