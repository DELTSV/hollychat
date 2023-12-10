part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class LoadPostPage extends PostsEvent {
  final int page;

  LoadPostPage({required this.page});
}
