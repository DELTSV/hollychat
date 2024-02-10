part of 'auth_bloc.dart';

class AuthState {
  final Auth? _auth;
  final Function? noAuthCallback;

  AuthState({Auth? auth, this.noAuthCallback}) : _auth = auth;

  AuthState withNewAuth(Auth? auth) => AuthState(
        auth: auth,
        noAuthCallback: noAuthCallback,
      );

  Auth? get auth {
    if (_auth == null) {
      noAuthCallback!();
    }
    return _auth;
  }

  bool get isAuthenticated => auth != null;
}
