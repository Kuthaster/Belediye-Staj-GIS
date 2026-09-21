import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/exception/api_exception.dart';
import 'package:frontend/models/create/user_create.dart';
import 'package:frontend/models/enum/role.dart';
import 'package:frontend/providers/object/user_providers.dart';
import 'package:frontend/widgets/create/admin/users/user_tile.dart';

/// Opens the "create user" dialog and, on success, invalidates
/// [adminUsersProvider] so the list refreshes. Call this from wherever
/// you place the "add user" action (e.g. an AppBar action or a FAB in
/// the screen that hosts [UserList]) — it deliberately isn't owned by
/// UserList itself, since that's a per-row/list-content widget, not the
/// screen chrome.
Future<void> createUser(BuildContext context, WidgetRef ref) async {
  try {
    final userService = ref.read(userServiceProvider);

    final userCreate = await showDialog<UserCreate>(
      context: context,
      builder: (dialogContext) {
        final nameController = TextEditingController();
        final emailController = TextEditingController();
        final rawPasswordController = TextEditingController();
        Role? selectedRole;
        bool obscurePassword = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Kullanıcı oluştur.'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'İsim'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'e-posta'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: rawPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: obscurePassword
                            ? Icon(Icons.visibility_off_sharp)
                            : Icon(Icons.visibility_sharp),
                        tooltip: 'Şifre görünürlüğünü aç/kapa',
                      ),
                    ),
                    obscureText: obscurePassword,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Role>(
                    initialValue: selectedRole,
                    decoration: const InputDecoration(labelText: 'Rol'),
                    hint: const Text('Rol seç'),
                    items: Role.values.map((role) {
                      return DropdownMenuItem<Role>(
                        value: role,
                        child: Text(role.displayName),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedRole = value),
                    validator: (value) =>
                        value == null ? 'Bir rol seçiniz' : null,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final rawPassword = rawPasswordController.text.trim();
                    if (name.isEmpty ||
                        email.isEmpty ||
                        rawPassword.isEmpty ||
                        selectedRole == null) {
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                      UserCreate(
                        name: name,
                        email: email,
                        rawPassword: rawPassword,
                        role: selectedRole!,
                      ),
                    );
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            );
          },
        );
      },
    );

    if (userCreate == null) return;

    await userService.createUser(userCreate);
    ref.invalidate(adminUsersProvider);
  } on DioException catch (e) {
    final errorMessage = (e.error is ApiException)
        ? (e.error as ApiException).message
        : 'Bilinmeyen bir ağ hatası oluştu.';
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('İşlem başarısız: $errorMessage')));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Oluşturulamadı: $e')));
    }
  }
}

class UserList extends ConsumerWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(adminUsersProvider);

    return asyncUsers.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Hata: $err')),
      data: (users) {
        return RefreshIndicator(
          onRefresh: () => ref.refresh(adminUsersProvider.future),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => UserTile(user: users[index]),
          ),
        );
      },
    );
  }
}
