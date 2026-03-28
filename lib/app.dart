import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'utils/lifecycle_logger.dart';

class WidgetConcernsApp extends StatefulWidget {
  static const name = 'WidgetConcernsApp';

  const WidgetConcernsApp({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<WidgetConcernsApp> createState() {
    LifecycleLogger.instance.log(name, 'createState');
    return _WidgetConcernsAppState();
  }
}

class _WidgetConcernsAppState extends State<WidgetConcernsApp> {
  ThemeMode _themeMode = ThemeMode.light;

  // ─── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    LifecycleLogger.instance.log(
      WidgetConcernsApp.name,
      'initState',
      detail: 'themeMode=$_themeMode',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LifecycleLogger.instance.log(
      WidgetConcernsApp.name,
      'didChangeDependencies',
    );
  }

  @override
  void didUpdateWidget(covariant WidgetConcernsApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    LifecycleLogger.instance.log(WidgetConcernsApp.name, 'didUpdateWidget');
  }

  @override
  void deactivate() {
    super.deactivate();
    LifecycleLogger.instance.log(WidgetConcernsApp.name, 'deactivate');
  }

  @override
  void dispose() {
    LifecycleLogger.instance.log(WidgetConcernsApp.name, 'dispose');
    super.dispose();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
    LifecycleLogger.instance.log(
      WidgetConcernsApp.name,
      'setState',
      detail: 'themeMode → $_themeMode',
    );
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Lifecycle Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: AppShell(onToggleTheme: _toggleTheme),
      // themeAnimationDuration: Duration(seconds: 0),
    );
  }
}
