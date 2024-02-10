import '../../models/minimal_post.dart';

abstract class PostsDataSource {
  Future<List<MinimalPost>> getAllPostsWithPagination(
      int pageNumber, int numberOfPostsPerRequest);
}
