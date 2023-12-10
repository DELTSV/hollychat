import 'package:hollychat/models/post.dart';

abstract class PostsDataSource {
  Future<List<Post>> getAllPostsWithPagination(
      int pageNumber, int numberOfPostsPerRequest);
}
