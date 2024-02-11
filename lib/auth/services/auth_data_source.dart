import 'package:dio/dio.dart';
import 'package:hollychat/models/auth.dart';

abstract class AuthDataSource {
  Future<Auth> signUp(
    String name,
    String email,
    String password,
  );

  Future<Auth> login(
    String email,
    String password,
  );
}

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
      return Auth.fromJson(response.data as Map<String, dynamic>);
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
      return Auth.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      rethrow;
    }
  }
}
