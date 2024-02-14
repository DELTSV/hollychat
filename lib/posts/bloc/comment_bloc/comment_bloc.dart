import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollychat/posts/services/comments/comments_repository.dart';


part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentsRepository commentsRepository;

  CommentBloc({required this.commentsRepository}) : super(CommentState()) {
    on<AddComment>(_onAddComment);
    on<UpdateComment>(_onUpdateComment);
    on<DeleteComment>(_onDeleteComment);
  }

  void _onAddComment(
    AddComment event,
    Emitter<CommentState> emit,
  ) async {
    if (state.status != CommentStatus.loading) {
      emit(state.copyWith(status: CommentStatus.loading));

      try {
        await commentsRepository.createComment(
          event.postId,
          event.content,
        );

        emit(
          state.copyWith(
            status: CommentStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: CommentStatus.error,
          ),
        );
      }
    }
  }

  void _onUpdateComment(
    UpdateComment event,
    Emitter<CommentState> emit,
  ) async {
    if (state.status != CommentStatus.loading) {
      emit(state.copyWith(status: CommentStatus.loading));

      try {
        await commentsRepository.updateComment(
          event.id,
          event.content,
        );

        emit(
          state.copyWith(
            status: CommentStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: CommentStatus.error,
          ),
        );
      }
    }
  }

  void _onDeleteComment(
    DeleteComment event,
    Emitter<CommentState> emit,
  ) async {
    if (state.status != CommentStatus.loading) {
      emit(state.copyWith(status: CommentStatus.loading));

      try {
        await commentsRepository.deleteComment(
          event.id,
        );

        emit(
          state.copyWith(
            status: CommentStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: CommentStatus.error,
          ),
        );
      }
    }
  }
}
