class Post {
  final String content;

  const Post({
    required this.content,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'],
    );
  }
}
