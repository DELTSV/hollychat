class PostAuthor {
  final String username;
  final int id;

  const PostAuthor({
    required this.username,
    required this.id,
  });

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      username: json['name'],
      id: json['id'],
    );
  }
}

class Post {
  final String content;
  final String? image;
  final PostAuthor author;

  const Post({
    required this.content,
    required this.author,
    this.image,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'],
      author: PostAuthor.fromJson(json['author']),
      image: getImageUrl(json),
    );
  }

  static String? getImageUrl(Map<String, dynamic> json) {
    return json['image'] == null ? null : json['image']['url'];
  }
}
