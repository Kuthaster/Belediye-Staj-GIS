import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/enum/role.dart';
import 'package:frontend/providers/core/auth_provider.dart';
import 'package:frontend/providers/user.provider.dart';
import 'package:frontend/screens/admin_screen.dart';
import 'package:frontend/screens/object_list_screen.dart';
import 'package:frontend/screens/object_map_screen.dart';
import 'package:frontend/widgets/account/profile_drawer.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  bool _isAdmin(Role role) => role.apiValue.contains('ADMIN');
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final isAdmin = user != null && _isAdmin(user.role);

    return Scaffold(
      appBar: AppBar(title: const Text('Coğrafi Nesne Takip Sistemi')),
      endDrawer: ProfileDrawer(),

      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 124,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ObjectMapScreen(),
                  ),
                );
              },
              icon: Icon(Icons.map),
            ),
            IconButton(
              iconSize: 124,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ObjectListScreen(),
                  ),
                );
              },
              icon: Icon(Icons.list_alt),
            ),
            if (isAdmin)
              IconButton(
                iconSize: 124,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const AdminScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.supervisor_account),
              ),
          ],
        ),
      ),
    );
  }
}
