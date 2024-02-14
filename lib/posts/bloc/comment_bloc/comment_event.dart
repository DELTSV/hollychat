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

class UpdateComment extends CommentEvent {
  final int id;
  final String content;

  UpdateComment({
    required this.id,
    required this.content,
  });
}

class DeleteComment extends CommentEvent {
  final int id;

  DeleteComment({
    required this.id,
  });
}