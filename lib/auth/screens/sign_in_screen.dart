import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/screens/sign_up_screen.dart';
import 'package:hollychat/auth/widgets/login_form.dart';
import 'package:hollychat/posts/screens/posts_screen.dart';

import '../../posts/widgets/linear_progress_bar.dart';
import '../bloc/auth_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  void _onLogin(BuildContext context, String email, String password) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(
      Login(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          Navigator.pushNamed(context, PostsScreen.routeName);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Se connecter'),
              bottom: LinearProgressBar(
                isLoading: state.status == AuthStatus.loading,
              ),
            ),
            body: SingleChildScrollView(
              child: Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 30),
                        const Image(
                          image: AssetImage('assets/images/logo.png'),
                          height: 35,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            LoginForm(
                              onSubmit: (email, password) => _onLogin(
                                context,
                                email,
                                password,
                              ),
                              isLoading: state.status == AuthStatus.loading,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Vous n'avez pas de compte ? "),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, SignUpScreen.routeName);
                                  },
                                  child: const Text('S\'inscrire'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
