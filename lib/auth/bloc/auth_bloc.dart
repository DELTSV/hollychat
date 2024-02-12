import 'package:bloc/bloc.dart';
import 'package:hollychat/auth/services/auth_repository.dart';
import 'package:hollychat/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository, Function? noAuthCallback})
      : super(AuthState(noAuthCallback: noAuthCallback)) {
    on<SignUp>(_onSigningUp);
    on<Login>(_onLogin);
    on<GetUser>(_onGetUser);
  }

  void _onSigningUp(SignUp event, Emitter<AuthState> emit) async {
    try {
      final auth = await authRepository.signUp(
        event.name,
        event.email,
        event.password,
      );
      emit(
        state.copyWith(
          user: auth.user,
          token: auth.token,
        ),
      );
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
      emit(
        state.copyWith(
          user: auth.user,
          token: auth.token,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  void _onGetUser(GetUser event, Emitter<AuthState> emit) async {
    try {
      final user = await authRepository.getUser();
      emit(
        state.copyWith(
          user: user,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }
}
