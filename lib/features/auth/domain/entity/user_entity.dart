class UserEntity {
  final String? userId;
  final String name;
  final String email;
  final String password;

  UserEntity({
    this.userId,
    required this.name,
    required this.email,
    required this.password,
  });
}
