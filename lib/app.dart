import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class WidgetConcernsApp extends StatefulWidget {
  const WidgetConcernsApp({super.key});

  @override
  State<WidgetConcernsApp> createState() => _WidgetConcernsAppState();
}

class _WidgetConcernsAppState extends State<WidgetConcernsApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

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
      home: HomeScreen(onToggleTheme: _toggleTheme),
    );
  }
}
