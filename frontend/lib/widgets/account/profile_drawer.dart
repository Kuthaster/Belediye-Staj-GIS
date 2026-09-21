import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/core/auth_provider.dart';
import 'package:frontend/widgets/account/change_password_form.dart';
import 'package:frontend/widgets/account/logout.dart';
import 'package:frontend/widgets/account/profile_avatar_widget.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final name = user?.name;
    final email = user?.email;
    final roleDisplayName = user?.role.displayName;

    return Drawer(
      width: 250,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusGeometry.all(Radius.elliptical(1, 6)),
            ),
            child: Column(
              children: [
                const ProfileAvatarWidget(),
                Text(name ?? 'AD'),
                Text(roleDisplayName ?? 'ROL'),
                const Icon(Icons.email, size: 16),
                const SizedBox(width: 8, height: 1),
                Text(email ?? 'BULUNAMADI'),
              ],
            ),
          ),

          Expanded(child: SizedBox()),
          //button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: FilledButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        enableDrag: true,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const ChangePasswordForm(),
                      );
                    },
                    icon: Icon(Icons.key),
                    label: Text('Şifre Değiştir'),
                  ),
                ),
                SizedBox(width: double.infinity, height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => logout(context, ref),
                    icon: Icon(Icons.logout),
                    label: Text('Çıkış Yap'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
