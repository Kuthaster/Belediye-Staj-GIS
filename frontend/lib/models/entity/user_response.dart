import 'package:frontend/models/enum/role.dart';

class UserResponse {
  final int id;
  final String name;
  final String email;
  final String roleDisplayName;
  final Role role;
  final bool mustChangePassword;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.roleDisplayName,
    required this.role,
    required this.mustChangePassword,
  });
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roleDisplayName: json['roleDisplayName'],
      role: Role.fromApiValue(json['role']),
      mustChangePassword: json['mustChangePassword'],
    );
  }
}
