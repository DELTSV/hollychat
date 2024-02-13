import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../services/posts_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostsRepository postsRepository;

  PostBloc({required this.postsRepository}) : super(PostState()) {
    on<AddNewPost>(_onPostCreated);
    on<UpdatePost>(_onPostUpdated);
  }

  void _onPostCreated(AddNewPost event, Emitter<PostState> emit) async {
    if (state.status != PostStatus.loading) {
      emit(state.copyWith(status: PostStatus.loading));

      try {
        await postsRepository.createPost(
          event.content,
          event.imageBytes,
        );

        emit(
          state.copyWith(
            status: PostStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: PostStatus.error,
          ),
        );
      }
    }
  }

  void _onPostUpdated(UpdatePost event, Emitter<PostState> emit) async {
    if (state.status != PostStatus.loading) {
      emit(state.copyWith(status: PostStatus.loading));

      try {
        await postsRepository.updatePost(
          event.id,
          event.content,
          event.imageBytes,
        );

        emit(
          state.copyWith(
            status: PostStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: PostStatus.error,
          ),
        );
      }
    }
  }
}
