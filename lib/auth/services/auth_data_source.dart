import 'package:hollychat/models/user.dart';

import '../../models/auth.dart';

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

  Future<User> getUser();
}