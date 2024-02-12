part of 'delete_post_bloc.dart';

@immutable
abstract class DeletePostEvent {}

class DeletePost extends DeletePostEvent {
  final int id;

  DeletePost({
    required this.id,
  });
}
