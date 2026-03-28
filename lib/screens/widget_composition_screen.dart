import 'package:flutter/material.dart';

import '../widgets/composition_demo/bad_composition_example.dart';
import '../widgets/composition_demo/good_composition_example.dart';

/// Demonstrates bad vs good widget composition.
///
/// **Bad**: counter state lives in the parent [StatefulWidget], so every tap
/// rebuilds the entire [build] method — including the three stat cards whose
/// data never changes.
///
/// **Good**: counter is extracted into its own [CounterButton] widget.
/// The stat cards are [const] [StatelessWidget]s ([StatCard]) that are never
/// rebuilt when the counter changes.
///
/// Use **Widget Rebuild Stats** in DevTools, then tap the counter button in
/// each mode to see the rebuild count difference.
class WidgetCompositionScreen extends StatefulWidget {
  final VoidCallback onOpenDrawer;

  const WidgetCompositionScreen({super.key, required this.onOpenDrawer});

  @override
  State<WidgetCompositionScreen> createState() =>
      _WidgetCompositionScreenState();
}

class _WidgetCompositionScreenState extends State<WidgetCompositionScreen> {
  bool _showGood = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Composition'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onOpenDrawer,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── DevTools hint ──────────────────────────────────────────────
            Container(
              color: Colors.orange.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.orange.shade800,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'DevTools → Widget Rebuild Stats: tap the counter in each '
                      'mode and compare which widgets increment their rebuild count.',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            // ── Toggle ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    label: Text('Bad — monolithic'),
                    icon: Icon(Icons.warning_amber_outlined),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text('Good — sliced'),
                    icon: Icon(Icons.check_circle_outline),
                  ),
                ],
                selected: {_showGood},
                onSelectionChanged: (s) => setState(() => _showGood = s.first),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _showGood
                    ? 'Counter is its own StatefulWidget. The stat cards are const '
                          'StatelessWidgets. Tap the counter — only CounterButton\'s '
                          'rebuild count goes up. The cards stay at 1.'
                    : 'Counter state lives in the parent. Every tap calls the '
                          'entire build() again — all three card subtrees are '
                          'reconstructed even though their data never changes.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            // ── Demo ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _showGood
                  ? const GoodCompositionExample()
                  : const BadCompositionExample(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
