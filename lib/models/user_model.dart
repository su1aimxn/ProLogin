class UserModel {
  final String id;
  final String userName;
  final String password;
  final String name;
  final String role;

  UserModel({
    required this.id,
    required this.userName,
    required this.password,
    required this.name,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      userName: json['user_name'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }
}