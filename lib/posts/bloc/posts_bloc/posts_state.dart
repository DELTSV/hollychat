part of 'posts_bloc.dart';

enum PostsStatus {
  initial,
  loading,
  success,
  error,
}

class PostsState {
  final List<MinimalPost> posts;
  final bool hasMore;
  final int nextPage;
  final PostsStatus status;

  PostsState({
    this.posts = const [],
    this.hasMore = true,
    this.nextPage = 1,
    this.status = PostsStatus.initial,
  });

  PostsState copyWith({
    List<MinimalPost>? posts,
    bool? hasMore,
    int? nextPage,
    PostsStatus? status,
    Exception? error,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
      status: status ?? this.status,
    );
  }
}