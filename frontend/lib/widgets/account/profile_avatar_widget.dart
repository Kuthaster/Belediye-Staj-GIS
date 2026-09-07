import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/core/auth_provider.dart';

class ProfileAvatarWidget extends ConsumerWidget {
  const ProfileAvatarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).value;
    final name = user!.name;

    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.black,
      child: Text(
        _getInitials(name),
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

String _getInitials(String? name) {
  final n = (name != null && name.isNotEmpty) ? name[0] : '';
  return (n).toUpperCase();
}
