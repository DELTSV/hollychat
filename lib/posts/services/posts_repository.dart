import 'package:hollychat/posts/services/posts_data_source.dart';

import '../../models/post.dart';

class PostsRepository {
  final PostsDataSource postsDataSource;

  PostsRepository({required this.postsDataSource});

  Future<List<Post>> getAllPostsWithPagination(
      int pageNumber, int numberOfPostsPerRequest) async {
    return postsDataSource.getAllPostsWithPagination(
        pageNumber, numberOfPostsPerRequest);
  }
}
