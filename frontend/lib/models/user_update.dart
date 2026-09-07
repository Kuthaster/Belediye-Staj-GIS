import 'package:frontend/models/enum/role.dart';

class UserUpdate {
  final String? name;
  final String? email;
  final Role? role;

  UserUpdate({this.name, this.email, this.role});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'role': role?.apiValue};
  }
}
