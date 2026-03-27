import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/lifecycle_logger.dart';

/// Demonstrates [didUpdateWidget].
///
/// When the parent passes a different [user] prop (via setState),
/// Flutter calls [didUpdateWidget] with the old widget so you can
/// react to the changed configuration.
class UserCard extends StatefulWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  static const _name = 'UserCard';

  @override
  void initState() {
    super.initState();
    LifecycleLogger.instance.log(
      _name,
      'initState',
      detail: 'user=${widget.user.userName}',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LifecycleLogger.instance.log(_name, 'didChangeDependencies');
  }

  /// Called whenever the parent widget rebuilds and passes a new config.
  /// [oldWidget] holds the previous widget so you can compare old vs new props.
  @override
  void didUpdateWidget(UserCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user != widget.user) {
      LifecycleLogger.instance.log(
        _name,
        'didUpdateWidget',
        detail: '${oldWidget.user.userName} → ${widget.user.userName}',
      );
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    LifecycleLogger.instance.log(_name, 'deactivate');
  }

  @override
  void dispose() {
    LifecycleLogger.instance.log(_name, 'dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              child: Text(
                widget.user.userName[0].toUpperCase(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.userName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(widget.user.email),
                  Text(widget.user.phoneNumber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
