import 'package:dio/dio.dart';
import 'package:wealthwise/services/api_service.dart';

class AuthRepository {
  Future<Response> signup({
    required String name,
    required String email,
    required String password,
    String? profileImage,
  }) async {
    return await ApiService.dio.post(
      "/auth/signup",
      data: {
        "name": name,
        "email": email,
        "password": password,
        "profileImage": profileImage,
      },
    );
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await ApiService.dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );
  }
}