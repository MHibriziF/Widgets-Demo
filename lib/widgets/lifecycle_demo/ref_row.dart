import 'package:flutter/material.dart';

class RefRow extends StatelessWidget {
  final String method;
  final Color color;
  final String description;

  const RefRow(this.method, this.color, this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 10, height: 10, color: color),
              const SizedBox(width: 6),
              Text(method, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 2),
          Text(description, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
