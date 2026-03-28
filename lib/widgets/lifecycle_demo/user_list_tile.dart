import 'package:flutter/material.dart';

import '../../models/user.dart';

class UserListTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserListTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(user.userName[0].toUpperCase())),
      title: Text(user.userName),
      subtitle: Text(user.email),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
