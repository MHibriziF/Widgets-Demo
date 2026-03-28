import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/user_service.dart';
import '../utils/lifecycle_logger.dart';
import '../widgets/log_panel.dart';
import 'user_detail_screen.dart';

/// Demonstrates: [initState], [didChangeDependencies], [setState],
/// [deactivate], [dispose].
///
/// - [initState]            → loads users from data.json on first build
/// - [didChangeDependencies] → fires after initState & when InheritedWidgets change
/// - [setState]             → called when users load or info changes
/// - [deactivate]           → fires when this screen is removed from the tree
/// - [dispose]              → fires after deactivate (permanent removal)
class HomeScreen extends StatefulWidget {
  static const name = 'HomeScreen';
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  // ignore: no_logic_in_create_state
  State<HomeScreen> createState() {
    LifecycleLogger.instance.log(name, 'createState');
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> _users = [];
  bool _loading = true;

  // ─── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // Called exactly once when this State object is inserted into the tree.
    // Safe to call setState indirectly (e.g. via async work).
    LifecycleLogger.instance.log(
      HomeScreen.name,
      'initState',
      detail: 'loading users from data.json',
    );
    _loadUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called after initState AND whenever an InheritedWidget this State
    // depends on changes. Calling Theme.of(context) here registers a
    // dependency on the Theme InheritedWidget — so this method fires again
    // whenever the theme changes (e.g. light ↔ dark toggle).
    final brightness = Theme.of(context).brightness;
    LifecycleLogger.instance.log(
      HomeScreen.name,
      'didChangeDependencies',
      detail: 'Theme.brightness → $brightness',
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    // Called when this State is removed from the widget tree — either
    // temporarily (e.g. moved) or permanently (just before dispose).
    LifecycleLogger.instance.log(HomeScreen.name, 'deactivate');
  }

  @override
  void dispose() {
    // Called after deactivate when the State is permanently removed.
    // Release resources here (controllers, streams, timers…).
    LifecycleLogger.instance.log(HomeScreen.name, 'dispose');
    super.dispose();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Future<void> _loadUsers() async {
    final users = await UserService.loadUsers();
    // setState schedules a rebuild and merges the new state.
    setState(() {
      _users = users;
      _loading = false;
    });
    LifecycleLogger.instance.log(
      HomeScreen.name,
      'setState',
      detail: 'users loaded (${users.length})',
    );
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Lifecycle Demo'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            tooltip: 'Toggle theme (triggers didChangeDependencies)',
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Lifecycle reference',
            onPressed: _showReference,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Tap a user → UserDetailScreen (didUpdateWidget demo)\n'
              'Watch the log below for lifecycle events.',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) => _buildUserTile(index),
                  ),
          ),
          const LogPanel(),
        ],
      ),
    );
  }

  Widget _buildUserTile(int index) {
    final user = _users[index];
    return ListTile(
      leading: CircleAvatar(child: Text(user.userName[0].toUpperCase())),
      title: Text(user.userName),
      subtitle: Text(user.email),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserDetailScreen(
              users: _users,
              initialIndex: index,
              onToggleTheme: widget.onToggleTheme,
            ),
          ),
        );
        // Rebuild to reflect any edits made in UserDetailScreen.
        setState(() {});
        LifecycleLogger.instance.log(
          HomeScreen.name,
          'setState',
          detail: 'returned from UserDetailScreen, refreshing list',
        );
      },
    );
  }

  void _showReference() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Lifecycle Quick Reference'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _RefRow(
                'initState',
                Colors.greenAccent,
                'Called once when the State is first created. '
                    'Good for one-time setup (controllers, subscriptions).',
              ),
              _RefRow(
                'didChangeDependencies',
                Colors.purpleAccent,
                'Called after initState and whenever an InheritedWidget '
                    'this State depends on changes (Theme, MediaQuery…).',
              ),
              _RefRow(
                'setState',
                Colors.lightBlueAccent,
                'Schedules a rebuild. Only call inside the widget; '
                    'never after dispose.',
              ),
              _RefRow(
                'didUpdateWidget',
                Colors.yellowAccent,
                'Called when the parent rebuilds and passes a new widget '
                    'with the same runtimeType. Compare old vs new props here.',
              ),
              _RefRow(
                'deactivate',
                Colors.orangeAccent,
                'Called when the State is removed from the tree '
                    '(temporarily or permanently, just before dispose).',
              ),
              _RefRow(
                'dispose',
                Colors.redAccent,
                'Called after deactivate on permanent removal. '
                    'Release all resources: controllers, streams, timers.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _RefRow extends StatelessWidget {
  final String method;
  final Color color;
  final String description;

  const _RefRow(this.method, this.color, this.description);

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
