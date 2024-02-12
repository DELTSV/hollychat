import 'package:hollychat/models/full_post.dart';

import '../../models/minimal_post.dart';

abstract class PostsDataSource {
  Future<List<MinimalPost>> getAllPostsWithPagination(
      int pageNumber, int numberOfPostsPerRequest);

  Future<FullPost> getPostDetailsById(int postId);

  Future<void> createPost(String content, List<int> imageBytes);
}
