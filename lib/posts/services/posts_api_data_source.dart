import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hollychat/models/full_post.dart';
import 'package:hollychat/posts/services/posts_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/minimal_post.dart';

class PostsApiDataSource extends PostsDataSource {
  final String baseUrl = 'https://xoc1-kd2t-7p9b.n7c.xano.io/api:xbcc5VEi';

  @override
  Future<List<MinimalPost>> getAllPostsWithPagination(
    int pageNumber,
    int numberOfPostsPerRequest,
  ) async {
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
        return MinimalPost.fromJson(jsonElement as Map<String, dynamic>);
      }).toList();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<FullPost> getPostDetailsById(int postId) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );

    try {
      final response = await dio.get('/post/$postId');
      return FullPost.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> createPost(String content, List<int> imageBytes) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("auth_token") ?? "";

      String base64Image =  "data:image/png;base64,${base64Encode(imageBytes)}";

      await dio.post(
        '/post',
        data: {
          'content': content,
          'base_64_image': base64Image,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } catch (error) {
      rethrow;
    }
  }
}
