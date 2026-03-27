import 'package:flutter/material.dart';

import '../utils/lifecycle_logger.dart';

class LogPanel extends StatelessWidget {
  const LogPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: LifecycleLogger.instance.logs,
      builder: (context, logs, _) {
        return Container(
          height: 200,
          color: const Color(0xFF1E1E1E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFF2D2D2D),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.terminal,
                      size: 14,
                      color: Colors.greenAccent,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Lifecycle Log',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${logs.length} events',
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: LifecycleLogger.instance.clear,
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.redAccent, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: logs.isEmpty
                    ? const Center(
                        child: Text(
                          'No lifecycle events yet',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        itemCount: logs.length,
                        itemBuilder: (_, i) {
                          final entry = logs[logs.length - 1 - i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Text(
                              entry,
                              style: TextStyle(
                                color: _colorFor(entry),
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        },
                      ),
              ),
              // Color legend
              Container(
                color: const Color(0xFF2D2D2D),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Legend('initState', Colors.greenAccent),
                      _Legend('didChangeDeps', Colors.purpleAccent),
                      _Legend('setState', Colors.lightBlueAccent),
                      _Legend('didUpdateWidget', Colors.yellowAccent),
                      _Legend('deactivate', Colors.orangeAccent),
                      _Legend('dispose', Colors.redAccent),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _colorFor(String entry) {
    if (entry.contains('initState')) return Colors.greenAccent;
    if (entry.contains('didChangeDependencies')) return Colors.purpleAccent;
    if (entry.contains('setState')) return Colors.lightBlueAccent;
    if (entry.contains('didUpdateWidget')) return Colors.yellowAccent;
    if (entry.contains('deactivate')) return Colors.orangeAccent;
    if (entry.contains('dispose')) return Colors.redAccent;
    return Colors.white70;
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;

  const _Legend(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(color: color, fontSize: 9)),
        ],
      ),
    );
  }
}
