part of 'post_details_bloc.dart';

enum PostDetailsStatus {
  initial,
  loading,
  success,
  error,
}

class PostDetailsState {
  final FullPost? postDetails;
  final PostDetailsStatus status;

  PostDetailsState({
    this.postDetails,
    this.status = PostDetailsStatus.initial,
  });

  PostDetailsState copyWith({
    FullPost? postDetails,
    PostDetailsStatus? status,
  }) {
    return PostDetailsState(
      postDetails: postDetails ?? this.postDetails,
      status: status ?? this.status,
    );
  }
}

class PostDetailsError extends PostDetailsState {
  final String errorMessage;

  PostDetailsError({required this.errorMessage}) : super();
}
