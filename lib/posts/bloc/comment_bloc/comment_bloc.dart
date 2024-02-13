import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../services/posts/posts_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final PostsRepository postsRepository;

  CommentBloc({required this.postsRepository}) : super(CommentState()) {
    on<AddComment>(_onDeletePost);
  }

  void _onDeletePost(
    AddComment event,
    Emitter<CommentState> emit,
  ) async {
    if (state.status != DeletePostStatus.loading) {
      emit(state.copyWith(status: DeletePostStatus.loading));

      try {
        await postsRepository.deletePost(
          event.postId,
        );

        emit(
          state.copyWith(
            status: DeletePostStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: DeletePostStatus.error,
          ),
        );
      }
    }
  }
}
