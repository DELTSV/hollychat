import 'package:hollychat/models/post.dart';
import 'package:hollychat/models/post_comment.dart';

class FullPost extends Post {
  final List<PostComment> comments;

  FullPost({
    required super.id,
    required super.content,
    required super.author,
    super.image,
    required this.comments,
  });

  factory FullPost.fromJson(Map<String, dynamic> json) {
    Post post = Post.fromJson(json);

    return FullPost(
      id: post.id,
      content: post.content,
      author: post.author,
      image: post.image,
      comments: (json['comments'] as List)
          .map((comment) => PostComment.fromJson(comment))
          .toList(),
    );
  }
}
