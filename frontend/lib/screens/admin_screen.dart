import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/widgets/account/profile_drawer.dart';
import 'package:frontend/widgets/create/admin/users/user_list.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Ekranı (Kullanıcı Yönetimi)')),
      endDrawer: ProfileDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createUser(context, ref),
        tooltip: 'Yeni Kullanıcı Oluştur',
        child: const Icon(Icons.person_add),
      ),
      body: const UserList(),
    );
  }
}
