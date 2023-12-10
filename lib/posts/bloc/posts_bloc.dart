import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/post.dart';
import '../services/posts_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;
  final int numberOfPostsPerRequest = 10;

  PostsBloc({required this.postsRepository}) : super(PostsState()) {
    on<LoadPostPage>(_onLoadPosts);
  }

  void _onLoadPosts(LoadPostPage event, Emitter<PostsState> emit) async {
    if (state.status != PostsStatus.loading && state.hasMore) {
      emit(state.copyWith(status: PostsStatus.loading));

      try {
        final List<Post> newPosts = await postsRepository
            .getAllPostsWithPagination(event.page, numberOfPostsPerRequest);

        emit(state.copyWith(
          posts: [...state.posts, ...newPosts],
          hasMore: newPosts.length == numberOfPostsPerRequest,
          nextPage: event.page + 1,
          status: PostsStatus.success,
        ));
      } catch (error) {
        emit(PostsError(errorMessage: "Failed to load posts"));
      }
    }
  }
}
