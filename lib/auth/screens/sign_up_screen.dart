import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/widgets/register_form.dart';
import 'package:hollychat/posts/screens/posts_screen.dart';

import '../../posts/widgets/linear_progress_bar.dart';
import '../bloc/auth_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void _onRegister(
      BuildContext context, String email, String username, String password) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(
      SignUp(
        email: email,
        name: username,
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
              title: const Text("S'inscrire"),
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
                        RegisterForm(
                          onSubmit: (email, username, password) => _onRegister(
                            context,
                            email,
                            username,
                            password,
                          ),
                          isLoading: state.status == AuthStatus.loading,
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
