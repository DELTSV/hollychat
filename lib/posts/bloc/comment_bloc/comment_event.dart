part of 'comment_bloc.dart';

@immutable
abstract class CommentEvent {}

class AddComment extends CommentEvent {
  final int postId;
  final String content;

  AddComment({
    required this.postId,
    required this.content,
  });
}
