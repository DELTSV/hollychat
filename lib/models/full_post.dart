import 'package:collection/collection.dart';
import 'package:hollychat/models/post.dart';
import 'package:hollychat/models/post_comment.dart';

class FullPost extends Post {
  final List<PostComment> comments;

  FullPost({
    required super.id,
    required super.content,
    required super.originalText,
    required super.author,
    super.image,
    required super.linkImages,
    required super.links,
    required super.linksPreviews,
    required this.comments,
    required super.createdAt,
  });

  factory FullPost.fromJson(Map<String, dynamic> json) {
    Post post = Post.fromJson(json);

    return FullPost(
      id: post.id,
      content: post.content,
      originalText: post.originalText,
      author: post.author,
      image: post.image,
      linkImages: post.linkImages,
      links: post.links,
      linksPreviews: post.linksPreviews,
      createdAt: post.createdAt,
      comments: (json['comments'] as List)
          .map((comment) => PostComment.fromJson(comment))
          .sortedBy((comment) => comment.createdAt)
          .toList(),
    );
  }
}
