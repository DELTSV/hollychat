part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class AddNewPost extends PostEvent {
  final String content;
  final List<int> imageBytes;

  AddNewPost({
    required this.content,
    required this.imageBytes,
  });
}

class UpdatePost extends PostEvent {
  final int id;
  final String content;
  final List<int> imageBytes;

  UpdatePost({
    required this.id,
    required this.content,
    required this.imageBytes,
  });
}

