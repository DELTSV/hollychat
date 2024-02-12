part of 'add_post_bloc.dart';

enum AddPostStatus {
  initial,
  loading,
  success,
  error,
}

class AddPostState {
  final AddPostStatus status;

  AddPostState({
    this.status = AddPostStatus.initial,
  });

  AddPostState copyWith({
    AddPostStatus? status,
  }) {
    return AddPostState(
      status: status ?? this.status,
    );
  }
}

class PostDetailsError extends AddPostState {
  final String errorMessage;

  PostDetailsError({required this.errorMessage}) : super();
}
