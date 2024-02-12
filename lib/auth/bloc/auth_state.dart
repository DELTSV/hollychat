part of 'auth_bloc.dart';

class AuthState {
  final Function? noAuthCallback;
  final String? token;
  final User? user;

  AuthState({
    this.token,
    this.user,
    this.noAuthCallback,
  });

  // Auth? get auth {
  //   if (_auth == null) {
  //     noAuthCallback!();
  //   }
  //   return _auth;
  // }

  AuthState copyWith({
    String? token,
    User? user,
    Function? noAuthCallback,
  }) {
    return AuthState(
      token: token ?? this.token,
      user: user ?? this.user,
      noAuthCallback: noAuthCallback ?? this.noAuthCallback,
    );
  }

  bool get isAuthenticated => token != null;
  bool get isNotAuthenticated => token == null;
}
