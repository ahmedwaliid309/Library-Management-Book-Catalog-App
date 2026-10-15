import 'package:flutter/material.dart';

/// شاشة مؤقتة. كل واحد يشيلها ويبني شاشته الحقيقية مكانها.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.owner,
    this.children = const [],
  });

  final String title;
  final String owner;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: text.headlineSmall),
                const SizedBox(height: 8),
                Text('المسؤول: $owner', style: text.bodyMedium),
                const SizedBox(height: 24),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
