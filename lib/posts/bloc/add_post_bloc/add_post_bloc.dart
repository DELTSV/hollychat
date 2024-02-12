import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../services/posts_repository.dart';

part 'add_post_event.dart';
part 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final PostsRepository postsRepository;

  AddPostBloc({required this.postsRepository}) : super(AddPostState()) {
    on<AddNewPost>(_onPostCreated);
  }

  void _onPostCreated(AddNewPost event, Emitter<AddPostState> emit) async {
    if (state.status != AddPostStatus.loading) {
      emit(state.copyWith(status: AddPostStatus.loading));

      try {
        await postsRepository.createPost(
          event.content,
          event.imageBytes,
        );

        emit(
          state.copyWith(
            status: AddPostStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: AddPostStatus.error,
          ),
        );
      }
    }
  }
}
