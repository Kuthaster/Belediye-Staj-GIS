import 'package:dio/dio.dart';
import 'package:frontend/models/change_password.dart';
import 'package:frontend/models/create/user_create.dart';
import 'package:frontend/models/entity/user_response.dart';
import 'package:frontend/models/user_update.dart';
import 'package:frontend/services/api_client.dart';

class UserService {
  final Dio _dio;

  UserService({Dio? dio}) : _dio = dio ?? dioClient;

  Future<List<UserResponse>> getAllUsers() async {
    final response = await _dio.get('/admin/users');
    return (response.data as List)
        .map((item) => UserResponse.fromJson(item))
        .toList();
  }

  Future<UserResponse> createUser(UserCreate dto) async {
    final response = await _dio.post('/admin/users', data: dto.toJson());

    return UserResponse.fromJson(response.data);
  }

  Future<UserResponse> updateUser(int userId, UserUpdate dto) async {
    final response = await _dio.put('/admin/users/$userId', data: dto.toJson());

    return UserResponse.fromJson(response.data);
  }

  Future<void> changePassword(ChangePassword dto) async {
    await _dio.patch('/users/profile/password', data: dto.toJson());
  }

  Future<void> deleteUser(int userId) async {
    await _dio.delete('/admin/users/$userId');
  }
}
