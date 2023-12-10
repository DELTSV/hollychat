part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class LoadNextPostPage extends PostsEvent {}

class RefreshPosts extends PostsEvent {}
