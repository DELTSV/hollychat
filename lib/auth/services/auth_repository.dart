import 'package:hollychat/auth/services/auth_data_source.dart';
import 'package:hollychat/models/auth.dart';

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
}
