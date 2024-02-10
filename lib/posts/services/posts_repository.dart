import 'package:hollychat/posts/services/posts_data_source.dart';

import '../../models/minimal_post.dart';
import '../../models/post.dart';

class PostsRepository {
  final PostsDataSource postsDataSource;

  PostsRepository({required this.postsDataSource});

  Future<List<MinimalPost>> getAllPostsWithPagination(
      int pageNumber, int numberOfPostsPerRequest) async {
    return postsDataSource.getAllPostsWithPagination(
        pageNumber, numberOfPostsPerRequest);
  }
}
