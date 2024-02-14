import 'package:bloc/bloc.dart';
import 'package:hollychat/auth/services/auth_repository.dart';
import 'package:hollychat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({
    required this.authRepository,
    Function? noAuthCallback,
  }) : super(AuthState(
          noAuthCallback: noAuthCallback,
          status: AuthStatus.initial,
        )) {
    on<SignUp>(_onSigningUp);
    on<Login>(_onLogin);
    on<GetUser>(_onGetUser);
    on<GetToken>(_onGetToken);
    on<LogOut>(_onLogOut);

    add(GetToken());
  }

  void _onGetToken(GetToken event, Emitter<AuthState> emit) async {
    final token = await _getToken();

    emit(
      state.copyWith(
        token: token,
      ),
    );

    if (token != null) {
      add(GetUser());
    }
  }

  void _onSigningUp(SignUp event, Emitter<AuthState> emit) async {
    if (state.status != AuthStatus.loading) {
      emit(
        state.copyWith(
          status: AuthStatus.loading,
        ),
      );
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
            status: AuthStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
          ),
        );
      }
    }
  }

  void _onLogin(Login event, Emitter<AuthState> emit) async {
    if (state.status != AuthStatus.loading) {
      try {
        emit(
          state.copyWith(
            status: AuthStatus.loading,
          ),
        );
        final auth = await authRepository.login(
          event.email,
          event.password,
        );
        emit(
          state.copyWith(
            user: auth.user,
            token: auth.token,
            status: AuthStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: AuthStatus.error,
          ),
        );
      }
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

  void _onLogOut(LogOut event, Emitter<AuthState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("auth_token");
    emit(state.reset());
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }
}
