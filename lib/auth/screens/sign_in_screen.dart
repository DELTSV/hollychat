import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/widgets/auth_form.dart';
import 'package:hollychat/posts/screens/posts_screen.dart';

import '../../posts/widgets/linear_progress_bar.dart';
import '../bloc/auth_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
            body: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 500,
              ),
              child: Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/logo.png'),
                          height: 35,
                        ),
                        // const Spacer(),
                        AuthForm(
                          onSubmit: (email, password) =>
                              _onLogin(context, email, password), isLoading: state.status == AuthStatus.loading,
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
