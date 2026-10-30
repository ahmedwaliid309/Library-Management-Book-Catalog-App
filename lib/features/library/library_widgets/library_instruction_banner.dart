import 'package:flutter/material.dart';

class LibraryInstructionBanner extends StatelessWidget {
  const LibraryInstructionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swap_horiz,
            color: colors.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'اضغط مطولًا واسحب الكتاب بين الرفوف',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}