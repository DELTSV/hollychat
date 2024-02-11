import 'package:hollychat/models/author.dart';
import 'package:hollychat/models/post_image.dart';

class Post {
  final int id;
  final String content;
  final PostImage? image;
  final Author author;

  const Post({
    required this.id,
    required this.content,
    required this.author,
    this.image,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      author: Author.fromJson(json['author']),
      image: json['image'] == null ? null : PostImage.fromJson(json['image']),
    );
  }
}
