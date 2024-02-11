import 'package:bloc/bloc.dart';
import 'package:hollychat/auth/services/auth_repository.dart';
import 'package:hollychat/models/auth.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository, Function? noAuthCallback})
      : super(AuthState(
          auth: null,
          noAuthCallback: noAuthCallback,
        )) {
    on<SignUp>(_onSigningUp);
    on<Login>(_onLogin);
  }

  void _onSigningUp(SignUp event, Emitter<AuthState> emit) async {
    try {
      final auth = await authRepository.signUp(
        event.name,
        event.email,
        event.password,
      );
      emit(state.withNewAuth(auth));
    } catch (error) {
      rethrow;
    }
  }

  void _onLogin(Login event, Emitter<AuthState> emit) async {
    try {
      final auth = await authRepository.login(
        event.email,
        event.password,
      );
      emit(state.withNewAuth(auth));
    } catch (error) {
      rethrow;
    }
  }
}
