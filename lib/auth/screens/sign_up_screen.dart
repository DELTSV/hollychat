import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/screens/sign_in_screen.dart';
import 'package:hollychat/auth/widgets/register_form.dart';
import 'package:hollychat/posts/screens/posts_screen.dart';

import '../../posts/widgets/linear_progress_bar.dart';
import '../bloc/auth_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  static Route? createRoute(RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignUpScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

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
            body: SingleChildScrollView(
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
                          RegisterForm(
                            onSubmit: (email, username, password) =>
                                _onRegister(
                              context,
                              email,
                              username,
                              password,
                            ),
                            isLoading: state.status == AuthStatus.loading,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Déjà inscrit ?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, SignInScreen.routeName);
                                },
                                child: const Text('Se connecter'),
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
          );
        },
      ),
    );
  }
}
