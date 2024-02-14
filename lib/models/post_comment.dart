import 'author.dart';

class PostComment {
  final int id;
  final String content;
  final Author author;

  const PostComment({
    required this.id,
    required this.content,
    required this.author,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'],
      content: json['content'],
      author: Author.fromJson(json['author']),
    );
  }
}