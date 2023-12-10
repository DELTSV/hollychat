import 'package:dio/dio.dart';
import 'package:hollychat/models/post.dart';
import 'package:hollychat/posts/services/posts_data_source.dart';

class PostsApiDataSource extends PostsDataSource {
  final String baseUrl = 'https://xoc1-kd2t-7p9b.n7c.xano.io/api:xbcc5VEi';

  @override
  Future<List<Post>> getAllPostsWithPagination(
      int pageNumber, int numberOfPostsPerRequest) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );

    try {
      final response = await dio.get('/post', queryParameters: {
        'page': pageNumber,
        'per_page': numberOfPostsPerRequest,
      });
      final jsonList = response.data['items'] as List;
      return jsonList.map((jsonElement) {
        return Post.fromJson(jsonElement as Map<String, dynamic>);
      }).toList();
    } catch (error) {
      rethrow;
    }
  }
}
