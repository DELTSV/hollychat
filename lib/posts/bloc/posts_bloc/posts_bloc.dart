import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../models/minimal_post.dart';
import '../../services/posts/posts_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;
  final int numberOfPostsPerRequest = 10;

  PostsBloc({required this.postsRepository})
      : super(PostsState()) {
    on<LoadNextPostPage>(_onLoadPosts);
    on<RefreshPosts>(_onRefreshPosts);
  }

  void _onLoadPosts(LoadNextPostPage event, Emitter<PostsState> emit) async {
    if (state.status != PostsStatus.loading && state.hasMore) {
      emit(state.copyWith(status: PostsStatus.loading));

      try {
        final List<MinimalPost> newPosts = await postsRepository
            .getAllPostsWithPagination(state.nextPage, numberOfPostsPerRequest);

        for(var post in newPosts) {
          post.getPreviews();
        }


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

      for(var post in newPosts) {
        post.getPreviews();
      }

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
