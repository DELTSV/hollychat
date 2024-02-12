import 'package:dio/dio.dart';
import 'package:hollychat/models/auth.dart';
import 'package:hollychat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_data_source.dart';

class AuthApiDataSource extends AuthDataSource {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://xoc1-kd2t-7p9b.n7c.xano.io/api:xbcc5VEi/auth',
    ),
  );

  @override
  Future<Auth> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post('/signup', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      Auth auth = Auth.fromJson(response.data as Map<String, dynamic>);

      _saveToken(auth.token);

      return auth;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Auth> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      Auth auth = Auth.fromJson(response.data as Map<String, dynamic>);

      _saveToken(auth.token);

      return auth;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<User> getUser() async {
    try {
      final response = await _dio.get(
        '/me',
        options: Options(
          headers: {
            ...await _getAuthorizationHeader(),
          },
        ),
      );

      return User.fromJson(response.data as Map<String, dynamic>);
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

  void _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("auth_token", token);
  }
}
