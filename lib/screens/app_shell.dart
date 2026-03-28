import 'package:flutter/material.dart';

import '../models/user.dart';
import 'home_screen.dart';
import 'logged_in_home_screen.dart';
import 'widget_composition_screen.dart';

class AppShell extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const AppShell({super.key, required this.onToggleTheme});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;
  User? _loggedInUser;

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _selectIndex(int i) {
    setState(() => _index = i);
    Navigator.pop(context);
  }

  void _loginAs(User user) => setState(() => _loggedInUser = user);

  void _logout() => setState(() => _loggedInUser = null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Widget Concerns',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                _index == 0 ? Icons.timeline : Icons.timeline_outlined,
              ),
              title: const Text('Lifecycle'),
              selected: _index == 0,
              onTap: () => _selectIndex(0),
            ),
            ListTile(
              leading: Icon(
                _index == 1 ? Icons.widgets : Icons.widgets_outlined,
              ),
              title: const Text('Composition'),
              selected: _index == 1,
              onTap: () => _selectIndex(1),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          // Type swap: HomeScreen ↔ LoggedInHomeScreen.
          // Same position, different runtimeType → Flutter disposes one State
          // and creates the other. Watch initState/dispose in the log panel.
          if (_loggedInUser == null)
            HomeScreen(
              onToggleTheme: widget.onToggleTheme,
              onOpenDrawer: _openDrawer,
              onLoginAs: _loginAs,
            )
          else
            LoggedInHomeScreen(
              loggedInUser: _loggedInUser!,
              onToggleTheme: widget.onToggleTheme,
              onOpenDrawer: _openDrawer,
              onLogout: _logout,
              onLoginAs: _loginAs,
            ),
          WidgetCompositionScreen(onOpenDrawer: _openDrawer),
        ],
      ),
    );
  }
}
