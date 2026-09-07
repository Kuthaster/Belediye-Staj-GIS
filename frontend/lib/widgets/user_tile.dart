import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/exception/api_exception.dart';
import 'package:frontend/models/entity/user_response.dart';
import 'package:frontend/models/enum/role.dart';
import 'package:frontend/models/user_update.dart';
import 'package:frontend/providers/user.provider.dart';
import 'package:frontend/services/user_service.dart';

class UserTile extends ConsumerStatefulWidget {
  final UserResponse user;
  const UserTile({super.key, required this.user});

  @override
  ConsumerState<UserTile> createState() => _UserTileState();
}

class _UserTileState extends ConsumerState<UserTile> {
  UserService get _userService => ref.read(userServiceProvider);

  Future<void> _editUser(BuildContext context, WidgetRef ref) async {
    final user = widget.user;
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    Role? selectedRole = user.role;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Kullanıcıyı Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ad'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-Posta'),
                keyboardType: TextInputType.emailAddress,
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
                validator: (value) => value == null ? 'Bir rol seçiniz' : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    try {
      await _userService.updateUser(
        user.id,
        UserUpdate(
          name: nameController.text,
          email: emailController.text,
          role: selectedRole,
        ),
      );
      ref.invalidate(adminUsersProvider);
    } on DioException catch (e) {
      final errorMessage = (e.error is ApiException)
          ? (e.error as ApiException).message
          : 'Bilinmeyen bir ağ hatası oluştu.';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İşlem başarısız: $errorMessage')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Güncellenemedi: $e')));
      }
    }
  }

  Future<void> _deleteUser(BuildContext context, WidgetRef ref) async {
    final user = widget.user;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Silme Onayı'),
          content: Text(
            'ID: ${user.id} Adı: ${user.name}\n'
            'E-posta: ${user.email}\n'
            'Rol: ${user.role.displayName}\n'
            'Kullanıcıyı Silmek İstediğinizden Emin misiniz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İPTAL ET'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('SİL'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      await _userService.deleteUser(user.id);
      ref.invalidate(adminUsersProvider);
    } on DioException catch (e) {
      final errorMessage = (e.error is ApiException)
          ? (e.error as ApiException).message
          : 'Bilinmeyen bir ağ hatası oluştu.';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İşlem başarısız: $errorMessage')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Silinemedi: $e')));
      }
    }
  }

  Widget _buildRow(BuildContext context, WidgetRef ref) {
    final user = widget.user;
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.roleDisplayName,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(user.email, style: const TextStyle(fontSize: 14)),
          if (user.mustChangePassword) ...[
            const SizedBox(height: 2),
            Text(
              'Şifre değişimi bekleniyor',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final row = _buildRow(context, ref);

    return Slidable(
      key: ValueKey(widget.user.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _editUser(context, ref),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Düzenle',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _deleteUser(context, ref),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Sil',
          ),
        ],
      ),
      child: row,
    );
  }
}
