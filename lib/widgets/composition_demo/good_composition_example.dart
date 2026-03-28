import 'package:flutter/material.dart';

import 'counter_button.dart';
import 'stat_card.dart';

/// Good composition: this widget is stateless and never rebuilds on its own.
/// [CounterButton] owns its state — only its build() is called on tap.
/// [StatCard] is a const [StatelessWidget] — its build() is never called again.
///
/// Use DevTools → Widget Rebuild Stats to confirm: only CounterButton's
/// rebuild count increments on each tap; StatCard stays at 1.
class GoodCompositionExample extends StatelessWidget {
  const GoodCompositionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: CounterButton()),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.people,
                label: 'Followers',
                value: '1,248',
              ),
            ),
            Expanded(
              child: StatCard(icon: Icons.article, label: 'Posts', value: '42'),
            ),
            Expanded(
              child: StatCard(
                icon: Icons.person_add,
                label: 'Following',
                value: '315',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
