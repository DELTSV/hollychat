class Author {
  final String username;
  final int id;

  const Author({
    required this.username,
    required this.id,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      username: json['name'],
      id: json['id'],
    );
  }
}