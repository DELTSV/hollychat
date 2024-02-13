import 'package:hollychat/posts/services/posts_data_source.dart';

import '../../models/full_post.dart';
import '../../models/minimal_post.dart';

class PostsRepository {
  final PostsDataSource postsDataSource;

  PostsRepository({required this.postsDataSource});

  Future<List<MinimalPost>> getAllPostsWithPagination(
      int pageNumber, int numberOfPostsPerRequest) async {
    return postsDataSource.getAllPostsWithPagination(
        pageNumber, numberOfPostsPerRequest);
  }

  Future<FullPost> getPostDetailsById(int postId) async {
    return postsDataSource.getPostDetailsById(postId);
  }

  Future<void> createPost(String content, List<int> imageBytes) async {
    return postsDataSource.createPost(content, imageBytes);
  }

  Future<void> deletePost(int postId) async {
    return postsDataSource.deletePost(postId);
  }

  Future<void> updatePost(int postId, String content, List<int> imageBytes) async {
    return postsDataSource.updatePost(postId, content, imageBytes);
  }
}
