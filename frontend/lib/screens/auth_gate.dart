import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/core/auth_provider.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/main_screen.dart';
import 'package:frontend/widgets/account/password_alert.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const LoginScreen(),
      data: (user) {
        if (user == null) return const LoginScreen();

        final shell = MainScreen();
        return PasswordAlert(child: shell);
      },
    );
  }
}
