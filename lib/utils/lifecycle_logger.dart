import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Singleton logger that captures widget lifecycle events.
/// Screens and widgets call [log] to record method invocations,
/// which are then displayed in the [LogPanel].
class LifecycleLogger {
  static final LifecycleLogger instance = LifecycleLogger._();
  LifecycleLogger._();

  final ValueNotifier<List<String>> logs = ValueNotifier(const []);

  // Buffer entries that arrive mid-frame so we can flush them after the frame.
  final List<String> _pending = [];

  void log(String widgetName, String method, {String? detail}) {
    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    final entry =
        '[$time] $widgetName.$method${detail != null ? ' → $detail' : ''}';

    debugPrint(entry);

    // Lifecycle methods (initState, didChangeDependencies, etc.) run during
    // the build phase. Updating a ValueNotifier synchronously at that point
    // triggers markNeedsBuild on the LogPanel, which Flutter forbids.
    // We buffer the entry and flush it in a post-frame callback instead.
    final schedulerPhase = SchedulerBinding.instance.schedulerPhase;
    final isMidFrame =
        schedulerPhase == SchedulerPhase.persistentCallbacks ||
        schedulerPhase == SchedulerPhase.transientCallbacks;

    if (isMidFrame) {
      _pending.add(entry);
      SchedulerBinding.instance.addPostFrameCallback((_) => _flush());
    } else {
      logs.value = [...logs.value, entry];
    }
  }

  void _flush() {
    if (_pending.isEmpty) return;
    logs.value = [...logs.value, ..._pending];
    _pending.clear();
  }

  void clear() {
    logs.value = const [];
  }
}
