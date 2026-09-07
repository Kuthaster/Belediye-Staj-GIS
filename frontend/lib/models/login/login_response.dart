import 'package:frontend/models/enum/role.dart';

class LoginResponse {
  final String token;
  final String tokenType;
  final int userId;
  final String email;
  final Role role;

  LoginResponse({
    required this.token,
    required this.tokenType,
    required this.userId,
    required this.email,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      tokenType: json['tokenType'],
      userId: json['userId'],
      email: json['email'],
      role: Role.fromApiValue(json['role']),
    );
  }
}
