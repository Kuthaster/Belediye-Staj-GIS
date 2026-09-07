import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/entity/user_response.dart';
import 'package:frontend/providers/core/dio_provider.dart';
import 'package:frontend/services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(dio: ref.watch(dioProvider));
});

final adminUsersProvider = FutureProvider<List<UserResponse>>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getAllUsers();
});
