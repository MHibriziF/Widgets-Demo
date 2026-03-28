import 'package:flutter/material.dart';

class CounterButton extends StatefulWidget {
  const CounterButton({super.key});

  @override
  State<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => setState(() => _count++),
      icon: const Icon(Icons.touch_app),
      label: Text('Taps: $_count  —  tap me, only I rebuild'),
    );
  }
}
