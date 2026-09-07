import 'package:frontend/models/enum/role.dart';

class UserCreate {
  final String name;
  final String email;
  final String rawPassword;
  Role role;

  UserCreate({
    required this.name,
    required this.email,
    required this.rawPassword,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'rawPassword': rawPassword,
      'role': role.apiValue,
    };
  }
}
