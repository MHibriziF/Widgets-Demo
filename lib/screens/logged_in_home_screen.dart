import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/user_service.dart';
import '../utils/lifecycle_logger.dart';
import '../widgets/lifecycle_demo/log_panel.dart';
import '../widgets/lifecycle_demo/user_list_tile.dart';
import 'user_detail_screen.dart';

/// Same position in the tree as [HomeScreen], but a different type.
///
/// When the user logs in, [AppShell] swaps [HomeScreen] for this widget.
/// Because the runtimeType changes, Flutter discards [HomeScreen]'s State
/// entirely and creates a fresh State for this widget — [initState] fires,
/// [HomeScreen.dispose] fires. Watch the log panel to see both.
///
/// Logging out reverses the swap: this widget's State is disposed and
/// [HomeScreen]'s State is created fresh again.
class LoggedInHomeScreen extends StatefulWidget {
  static const name = 'LoggedInHomeScreen';
  final User loggedInUser;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenDrawer;
  final VoidCallback onLogout;
  final void Function(User user) onLoginAs;

  const LoggedInHomeScreen({
    super.key,
    required this.loggedInUser,
    required this.onToggleTheme,
    required this.onOpenDrawer,
    required this.onLogout,
    required this.onLoginAs,
  });

  @override
  // ignore: no_logic_in_create_state
  State<LoggedInHomeScreen> createState() {
    LifecycleLogger.instance.log(name, 'createState');
    return _LoggedInHomeScreenState();
  }
}

class _LoggedInHomeScreenState extends State<LoggedInHomeScreen> {
  List<User> _users = [];
  bool _loading = true;

  // ─── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    LifecycleLogger.instance.log(
      LoggedInHomeScreen.name,
      'initState',
      detail:
          'type swap from HomeScreen — fresh State created for ${widget.loggedInUser.userName}',
    );
    _loadUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    LifecycleLogger.instance.log(
      LoggedInHomeScreen.name,
      'didChangeDependencies',
      detail: 'Theme.brightness → $brightness',
    );
  }

  @override
  void didUpdateWidget(covariant LoggedInHomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    LifecycleLogger.instance.log(
      LoggedInHomeScreen.name,
      'didUpdateWidget',
      detail: 'loggedInUser → ${widget.loggedInUser.userName}',
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    LifecycleLogger.instance.log(LoggedInHomeScreen.name, 'deactivate');
  }

  @override
  void dispose() {
    LifecycleLogger.instance.log(
      LoggedInHomeScreen.name,
      'dispose',
      detail: 'type swap back to HomeScreen — this State is gone',
    );
    super.dispose();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Future<void> _loadUsers() async {
    final users = await UserService.loadUsers();
    setState(() {
      _users = users;
      _loading = false;
    });
    LifecycleLogger.instance.log(
      LoggedInHomeScreen.name,
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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.onOpenDrawer,
        ),
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
            icon: const Icon(Icons.logout),
            tooltip: 'Logout — swaps back to HomeScreen',
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.green.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Logged in as ${widget.loggedInUser.userName}. '
              'Check the log — HomeScreen.dispose and LoggedInHomeScreen.initState fired.',
              style: const TextStyle(fontSize: 12, color: Colors.green),
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
          _GreetingFooter(userName: widget.loggedInUser.userName),
          const LogPanel(),
        ],
      ),
    );
  }

  Widget _buildUserTile(int index) {
    return UserListTile(
      user: _users[index],
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserDetailScreen(
              users: _users,
              initialIndex: index,
              onToggleTheme: widget.onToggleTheme,
              onLoginAs: widget.onLoginAs,
            ),
          ),
        );
        setState(() {});
        LifecycleLogger.instance.log(
          LoggedInHomeScreen.name,
          'setState',
          detail: 'returned from UserDetailScreen, refreshing list',
        );
      },
    );
  }
}

class _GreetingFooter extends StatelessWidget {
  final String userName;

  const _GreetingFooter({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        'Hello, $userName!',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
