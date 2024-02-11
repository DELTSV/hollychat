class User {
  final int id;
  final int createdAt;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      createdAt: json['created_at'],
      name: json['name'],
      email: json['email'],
    );
  }
}
