part of 'comment_bloc.dart';

enum CommentStatus {
  initial,
  loading,
  success,
  error,
}

class CommentState {
  final CommentStatus status;

  CommentState({
    this.status = CommentStatus.initial,
  });

  CommentState copyWith({
    CommentStatus? status,
  }) {
    return CommentState(
      status: status ?? this.status,
    );
  }
}