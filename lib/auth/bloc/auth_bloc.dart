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
  }) : super(AuthState(noAuthCallback: noAuthCallback),) {
    on<SignUp>(_onSigningUp);
    on<Login>(_onLogin);
    on<GetUser>(_onGetUser);
    on<GetToken>(_onGetToken);

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
      print(user);
      emit(
        state.copyWith(
          user: user,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }
}
