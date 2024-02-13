part of 'post_bloc.dart';

enum PostStatus {
  initial,
  loading,
  success,
  error,
}

class PostState {
  final PostStatus status;

  PostState({
    this.status = PostStatus.initial,
  });

  PostState copyWith({
    PostStatus? status,
  }) {
    return PostState(
      status: status ?? this.status,
    );
  }
}
