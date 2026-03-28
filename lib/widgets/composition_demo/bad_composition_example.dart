import 'package:flutter/material.dart';

/// Bad composition: counter state lives in this widget, so every tap
/// rebuilds the entire build() — including the three stat cards whose
/// data never changes.
class BadCompositionExample extends StatefulWidget {
  const BadCompositionExample({super.key});

  @override
  State<BadCompositionExample> createState() => _BadCompositionExampleState();
}

class _BadCompositionExampleState extends State<BadCompositionExample> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: FilledButton.icon(
            onPressed: () => setState(() => _count++),
            icon: const Icon(Icons.touch_app),
            label: Text('Taps: $_count  —  tap me, watch everything rebuild'),
          ),
        ),
        const SizedBox(height: 16),

        // Same Container/Column/Icon/Text structure repeated 3×.
        // All three rebuild on every tap because they share a build() with _count.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.people, size: 28, color: scheme.primary),
                    const SizedBox(height: 4),
                    const Text(
                      'Followers',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const Text(
                      '1,248',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.article, size: 28, color: scheme.primary),
                    const SizedBox(height: 4),
                    const Text(
                      'Posts',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const Text(
                      '42',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.person_add, size: 28, color: scheme.primary),
                    const SizedBox(height: 4),
                    const Text(
                      'Following',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const Text(
                      '315',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
