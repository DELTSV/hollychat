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

  AuthState reset() {
    return AuthState(
      token: null,
      user: null,
      noAuthCallback: noAuthCallback,
    );
  }

  bool get isAuthenticated => user != null;
  bool get isNotAuthenticated => user == null;
}
