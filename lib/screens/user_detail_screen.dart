import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/lifecycle_logger.dart';
import '../widgets/lifecycle_demo/log_panel.dart';
import '../widgets/lifecycle_demo/user_card.dart';

/// Demonstrates: [didUpdateWidget] (via [UserCard]), [deactivate], [dispose].
///
/// - Tap **Prev / Next** → setState changes the current user, which causes
///   [UserCard.didUpdateWidget] to fire and the profile controllers to sync.
/// - Press **Back** → [deactivate] fires, then [dispose] fires.
///   All three [TextEditingController]s are cleaned up inside [dispose].
class UserDetailScreen extends StatefulWidget {
  static const name = 'UserDetailScreen';
  final List<User> users;
  final int initialIndex;
  final VoidCallback onToggleTheme;

  const UserDetailScreen({
    super.key,
    required this.users,
    required this.initialIndex,
    required this.onToggleTheme,
  });

  @override
  // ignore: no_logic_in_create_state
  State<UserDetailScreen> createState() {
    LifecycleLogger.instance.log(name, 'createState');
    return _UserDetailScreenState();
  }
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late int _currentIndex;
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // ─── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Create one controller per profile field — all must be disposed in dispose().
    final user = widget.users[_currentIndex];
    _userNameController = TextEditingController(text: user.userName);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phoneNumber);
    LifecycleLogger.instance.log(
      UserDetailScreen.name,
      'initState',
      detail: 'user=${user.userName}, 3×TextEditingController created',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LifecycleLogger.instance.log(
      UserDetailScreen.name,
      'didChangeDependencies',
    );
  }

  @override
  void didUpdateWidget(covariant UserDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fires if a parent widget rebuilds and passes a new UserDetailScreen
    // widget (same runtimeType, same key).
    LifecycleLogger.instance.log(
      UserDetailScreen.name,
      'didUpdateWidget',
      detail: 'parent passed updated widget config',
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    // Fires when this State is removed from the widget tree.
    // At this point the State is still valid — avoid using it for cleanup
    // (use dispose for that). You CAN re-insert the widget into the tree
    // after deactivate; dispose means it's gone for good.
    LifecycleLogger.instance.log(
      UserDetailScreen.name,
      'deactivate',
      detail: 'removed from tree (navigating back)',
    );
  }

  @override
  void dispose() {
    // Permanent removal — release all resources here.
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    LifecycleLogger.instance.log(
      UserDetailScreen.name,
      'dispose',
      detail: '3×TextEditingController disposed, State permanently removed',
    );
    super.dispose();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  void _prev() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.users.length) % widget.users.length;
      _syncControllers(widget.users[_currentIndex]);
    });
    LifecycleLogger.instance.log(
      UserDetailScreen.name,
      'setState',
      detail:
          '→ ${widget.users[_currentIndex].userName} '
          '(controllers synced, triggers UserCard.didUpdateWidget)',
    );
  }

  void _next() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.users.length;
      _syncControllers(widget.users[_currentIndex]);
    });
    LifecycleLogger.instance.log(
      UserDetailScreen.name,
      'setState',
      detail:
          '→ ${widget.users[_currentIndex].userName} '
          '(controllers synced, triggers UserCard.didUpdateWidget)',
    );
  }

  void _saveUser() {
    final updated = widget.users[_currentIndex].copyWith(
      userName: _userNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
    );

    setState(() {
      widget.users[_currentIndex] = updated;
      LifecycleLogger.instance.log(
        UserDetailScreen.name,
        'setState',
        detail: 'saved edits for ${updated.userName}',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User saved'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _syncControllers(User user) {
    _userNameController.text = user.userName;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber;
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final user = widget.users[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(user.userName),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Section: didUpdateWidget ──────────────────────────────
                _sectionLabel(
                  'UserCard — demonstrates didUpdateWidget',
                  'Each Prev/Next tap changes the user prop passed to UserCard. '
                      'Flutter calls UserCard.didUpdateWidget with the old widget.',
                ),
                UserCard(user: user),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _prev,
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Prev'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: _next,
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Next'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Section: dispose ──────────────────────────────────────
                _sectionLabel(
                  'Profile fields — demonstrates dispose',
                  '3×TextEditingController created in initState, synced on '
                      'Prev/Next, disposed in dispose(). Press Back to see deactivate → dispose.',
                ),
                TextField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _saveUser,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
                const SizedBox(height: 8),
                const Text(
                  '← Press Back: deactivate fires, then dispose fires',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const LogPanel(),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
