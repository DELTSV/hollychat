import 'package:hollychat/models/author.dart';

class Post {
  final double id;
  final String content;
  final String? image;
  final Author author;

  const Post({
    required this.id,
    required this.content,
    required this.author,
    this.image,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: double.parse(json['id'].toString()),
      content: json['content'],
      author: Author.fromJson(json['author']),
      image: getImageUrl(json),
    );
  }

  static String? getImageUrl(Map<String, dynamic> json) {
    return json['image'] == null ? null : json['image']['url'];
  }
}
