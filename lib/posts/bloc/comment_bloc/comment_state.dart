part of 'comment_bloc.dart';

enum DeletePostStatus {
  initial,
  loading,
  success,
  error,
}

class CommentState {
  final DeletePostStatus status;

  CommentState({
    this.status = DeletePostStatus.initial,
  });

  CommentState copyWith({
    DeletePostStatus? status,
  }) {
    return CommentState(
      status: status ?? this.status,
    );
  }
}