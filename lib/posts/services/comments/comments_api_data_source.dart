import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hollychat/models/full_post.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/minimal_post.dart';
import 'comments_data_source.dart';

class CommentsApiDataSource extends CommentsDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://xoc1-kd2t-7p9b.n7c.xano.io/api:xbcc5VEi/post',
    ),
  );

  @override
  Future<List<MinimalPost>> getAllPostsWithPagination(
    int pageNumber,
    int numberOfPostsPerRequest,
  ) async {
    try {
      final response = await dio.get('', queryParameters: {
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
    try {
      final response = await dio.get('/$postId');
      return FullPost.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> createPost(String content, List<int> imageBytes) async {
    try {
      await dio.post(
        '',
        data: {
          'content': content,
          'base_64_image': encodeImage(imageBytes),
        },
        options: Options(headers: {
          ...await _getAuthorizationHeader(),
        }),
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> deletePost(int postId) async {
    try {
      await dio.delete(
        '/$postId',
        options: Options(headers: {
          ...await _getAuthorizationHeader(),
        }),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, String>> _getAuthorizationHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("auth_token") ?? "";

    return {
      'Authorization': 'Bearer $token',
    };
  }

  String? encodeImage(List<int> imageBytes) {
    if (imageBytes.isEmpty) {
      return null;
    }

    return "data:image/png;base64,${base64Encode(imageBytes)}";
  }

  @override
  Future<void> updatePost(int postId, String content, List<int> imageBytes) async {
    try {
      await dio.patch(
        '/$postId',
        data: {
          'content': content,
          'base_64_image': encodeImage(imageBytes),
        },
        options: Options(headers: {
          ...await _getAuthorizationHeader(),
        }),
      );
    } catch (error) {
      rethrow;
    }
  }
}
