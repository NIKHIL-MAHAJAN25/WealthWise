import 'user.dart';

class AuthResponse {
  final String token;
  final UserModel user;

  const AuthResponse({
    required this.token,
    required this.user,
  });
}