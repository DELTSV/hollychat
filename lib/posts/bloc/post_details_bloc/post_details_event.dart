part of 'post_details_bloc.dart';

@immutable
abstract class PostDetailsEvent {}

class LoadPostDetailsById extends PostDetailsEvent {
  final int postId;

  LoadPostDetailsById({required this.postId});
}