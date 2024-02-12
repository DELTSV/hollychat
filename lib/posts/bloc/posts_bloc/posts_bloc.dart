import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../models/minimal_post.dart';
import '../../services/posts_repository.dart';
import '../delete_post_bloc/delete_post_bloc.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;
  final int numberOfPostsPerRequest = 10;
  final DeletePostBloc deletePostBloc;

  PostsBloc({required this.postsRepository, required this.deletePostBloc})
      : super(PostsState()) {
    on<LoadNextPostPage>(_onLoadPosts);
    on<RefreshPosts>(_onRefreshPosts);

    deletePostBloc.stream.listen((deletePostState) {
      print("deletePostState: $deletePostState");
      if (deletePostState.status == DeletePostStatus.success) {
        add(RefreshPosts());
      }
    });
  }

  void _onLoadPosts(LoadNextPostPage event, Emitter<PostsState> emit) async {
    if (state.status != PostsStatus.loading && state.hasMore) {
      emit(state.copyWith(status: PostsStatus.loading));

      try {
        final List<MinimalPost> newPosts = await postsRepository
            .getAllPostsWithPagination(state.nextPage, numberOfPostsPerRequest);

        emit(state.copyWith(
          posts: [...state.posts, ...newPosts],
          hasMore: newPosts.length == numberOfPostsPerRequest,
          nextPage: state.nextPage + 1,
          status: PostsStatus.success,
        ));
      } catch (error) {
        emit(state.copyWith(status: PostsStatus.error));
      }
    }
  }

  void _onRefreshPosts(RefreshPosts event, Emitter<PostsState> emit) async {
    emit(state.copyWith(status: PostsStatus.loading, posts: []));

    try {
      final List<MinimalPost> newPosts = await postsRepository
          .getAllPostsWithPagination(1, numberOfPostsPerRequest);

      emit(state.copyWith(
        posts: newPosts,
        hasMore: newPosts.length == numberOfPostsPerRequest,
        nextPage: 2,
        status: PostsStatus.success,
      ));
    } catch (error) {
      emit(state.copyWith(status: PostsStatus.error));
    }
  }
}
