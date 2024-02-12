part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class SignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUp({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class Login extends AuthEvent {
  final String email;
  final String password;

  Login({
    required this.email,
    required this.password,
  });
}

final class GetUser extends AuthEvent {}
