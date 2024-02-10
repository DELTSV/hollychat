import 'package:hollychat/models/user.dart';

class Auth {
  final String token;
  final User user;

  const Auth({
    required this.token,
    required this.user,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      token: json['authToken'],
      user: User.fromJson(json['user']),
    );
  }
}
