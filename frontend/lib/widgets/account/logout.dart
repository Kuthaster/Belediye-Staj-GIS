import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/core/auth_provider.dart';

void logout(BuildContext context, WidgetRef ref) {
  ref.read(authProvider.notifier).logout();
  Navigator.of(context).popUntil((route) => route.isFirst);
}
