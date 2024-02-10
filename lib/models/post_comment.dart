import 'author.dart';

class PostComment {
  final String content;
  final Author author;

  const PostComment({
    required this.content,
    required this.author,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      content: json['content'],
      author: Author.fromJson(json['author']),
    );
  }
}