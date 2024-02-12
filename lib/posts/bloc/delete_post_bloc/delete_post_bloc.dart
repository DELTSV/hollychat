import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../services/posts_repository.dart';

part 'delete_post_event.dart';
part 'delete_post_state.dart';

class DeletePostBloc extends Bloc<DeletePostEvent, DeletePostState> {
  final PostsRepository postsRepository;

  DeletePostBloc({required this.postsRepository}) : super(DeletePostState()) {
    on<DeletePost>(_onDeletePost);
  }

  void _onDeletePost(
    DeletePost event,
    Emitter<DeletePostState> emit,
  ) async {
    if (state.status != DeletePostStatus.loading) {
      emit(state.copyWith(status: DeletePostStatus.loading));

      try {
        await postsRepository.deletePost(
          event.id,
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
