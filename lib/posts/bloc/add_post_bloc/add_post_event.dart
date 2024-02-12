part of 'add_post_bloc.dart';

@immutable
abstract class AddPostEvent {}

class AddNewPost extends AddPostEvent {
  final String content;
  final List<int> imageBytes;

  AddNewPost({
    required this.content,
    required this.imageBytes,
  });
}
