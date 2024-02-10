import 'package:hollychat/models/post.dart';

class MinimalPost extends Post {
  final double commentsCount;

  MinimalPost({
    required super.id,
    required super.content,
    required super.author,
    super.image,
    required this.commentsCount,
  });

  factory MinimalPost.fromJson(Map<String, dynamic> json) {
    Post post = Post.fromJson(json);

    return MinimalPost(
      id: post.id,
      content: post.content,
      author: post.author,
      image: post.image,
      commentsCount: double.parse(json['comments_count'].toString()),
    );
  }
}