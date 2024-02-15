import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollychat/models/full_post.dart';

import '../../services/posts/posts_repository.dart';

part 'post_details_event.dart';

part 'post_details_state.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final PostsRepository postsRepository;

  PostDetailsBloc({required this.postsRepository}) : super(PostDetailsState()) {
    on<LoadPostDetailsById>(_onLoadPosts);
  }

  void _onLoadPosts(LoadPostDetailsById event,
      Emitter<PostDetailsState> emit) async {
    if (state.status != PostDetailsStatus.loading) {
      emit(state.copyWith(status: PostDetailsStatus.loading));

      try {
        final FullPost postDetails =
        await postsRepository.getPostDetailsById(event.postId);

        postDetails.getPreviews();

        for (var comment in postDetails.comments) {
          comment.getPreviews();
        }

        emit(state.copyWith(
          postDetails: postDetails,
          status: PostDetailsStatus.success,
        ));
      } catch (error) {
        emit(state.copyWith(
          status: PostDetailsStatus.error,
        ));
      }
    }
  }
}
