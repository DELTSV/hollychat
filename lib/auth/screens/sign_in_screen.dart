import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/widgets/auth_form.dart';

import '../bloc/auth_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/images/logo.png'),
                height: 30,
              ),
              const Spacer(),
              AuthForm(onSubmit: (email, password) {
                final authBloc = BlocProvider.of<AuthBloc>(context);
                authBloc.add(
                  Login(
                    email: email,
                    password: password,
                  ),
                );
                Navigator.pop(context);
              }),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
