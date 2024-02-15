import 'package:hollychat/models/post.dart';

class MinimalPost extends Post {
  final int commentsCount;

  MinimalPost({
    required super.id,
    required super.content,
    required super.originalText,
    required super.author,
    required super.image,
    required super.linkImages,
    required super.links,
    required super.linksPreviews,
    required this.commentsCount,
    required super.createdAt,
  });

  factory MinimalPost.fromJson(Map<String, dynamic> json) {
    Post post = Post.fromJson(json);

    return MinimalPost(
      id: post.id,
      content: post.content,
      originalText: post.originalText,
      author: post.author,
      image: post.image,
      linkImages: post.linkImages,
      links: post.links,
      linksPreviews: post.linksPreviews,
      createdAt: post.createdAt,
      commentsCount: json['comments_count'],
    );
  }
}