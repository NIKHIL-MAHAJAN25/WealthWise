class UserModel {
  final String id;

  final String name;

  final String email;

  final String? profileImage;

  final bool isPremium;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.isPremium = false,
  });
}