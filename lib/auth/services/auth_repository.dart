import 'package:hollychat/models/auth.dart';
import 'package:hollychat/models/user.dart';

import 'auth_data_source.dart';

class AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepository({required this.authDataSource});

  Future<Auth> signUp(
    String name,
    String email,
    String password,
  ) async {
    return authDataSource.signUp(
      name,
      email,
      password,
    );
  }

  Future<Auth> login(
    String email,
    String password,
  ) async {
    return authDataSource.login(
      email,
      password,
    );
  }

  Future<User> getUser() async {
    return authDataSource.getUser();
  }
}
