import 'package:dio/dio.dart';
import 'package:hollychat/models/auth.dart';

abstract class AuthDataSource {
  Future<Auth> signUp(
    String name,
    String email,
    String password,
  );
}

class AuthApiDataSource extends AuthDataSource {
  final String baseUrl = 'https://xoc1-kd2t-7p9b.n7c.xano.io/api:xbcc5VEi/auth';

  @override
  Future<Auth> signUp(
    String name,
    String email,
    String password,
  ) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );

    try {
      final response = await dio.post('/post', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return Auth.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      rethrow;
    }
  }
}
