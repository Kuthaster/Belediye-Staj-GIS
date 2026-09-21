import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/core/auth_provider.dart';
import 'package:frontend/screens/admin_screen.dart';
import 'package:frontend/screens/object_list_screen.dart';
import 'package:frontend/screens/object_map_screen.dart';
import 'package:frontend/widgets/account/profile_drawer.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final isAdmin = user != null && user.role.isAdmin;

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
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: ContinuousRectangleBorder(),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ObjectMapScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(Icons.map, size: 124),
                  SizedBox(height: 6),
                  Text("Harita"),
                ],
              ),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: ContinuousRectangleBorder(),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ObjectListScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  Icon(Icons.list_alt, size: 124),
                  SizedBox(height: 6),
                  Text("Cisim Listesi"),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (isAdmin)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: ContinuousRectangleBorder(),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const AdminScreen(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Icon(Icons.supervisor_account, size: 124),
                    SizedBox(height: 6),
                    Text("Kullanıcı Yönetimi"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
