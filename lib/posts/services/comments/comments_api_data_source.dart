import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'comments_data_source.dart';

class CommentsApiDataSource extends CommentsDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://xoc1-kd2t-7p9b.n7c.xano.io/api:xbcc5VEi/comment',
    ),
  );

  @override
  Future<void> createComment(int postId, String content) async {
    try {
      await dio.post(
        '',
        data: {
          'post_id': postId,
          'content': content,
        },
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

  @override
  Future<void> deleteComment(int commentId) async {
    try {
      await dio.delete(
        '/$commentId',
        options: Options(headers: {
          ...await _getAuthorizationHeader(),
        }),
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> updateComment(int commentId, String content) async {
    try {
      await dio.patch(
        '/$commentId',
        data: {
          'content': content,
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
