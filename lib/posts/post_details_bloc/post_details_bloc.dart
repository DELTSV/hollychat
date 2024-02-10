
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'post_details_event.dart';
part 'post_details_state.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  PostDetailsBloc() : super(PostDetailsInitial()) {
    on<PostDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
