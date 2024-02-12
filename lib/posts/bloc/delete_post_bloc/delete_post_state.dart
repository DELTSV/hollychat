part of 'delete_post_bloc.dart';

enum DeletePostStatus {
  initial,
  loading,
  success,
  error,
}

class DeletePostState {
  final DeletePostStatus status;

  DeletePostState({
    this.status = DeletePostStatus.initial,
  });

  DeletePostState copyWith({
    DeletePostStatus? status,
  }) {
    return DeletePostState(
      status: status ?? this.status,
    );
  }
}