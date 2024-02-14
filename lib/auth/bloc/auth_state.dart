part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  error,
}

class AuthState {
  final AuthStatus status;
  final Function? noAuthCallback;
  final String? token;
  final User? user;

  AuthState({
    required this.status,
    this.token,
    this.user,
    this.noAuthCallback,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    User? user,
    Function? noAuthCallback,
  }) {
    return AuthState(
      status: status ?? this.status,
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
      status: AuthStatus.initial,
    );
  }

  bool get isAuthenticated => user != null;

  bool get isNotAuthenticated => user == null;
}
