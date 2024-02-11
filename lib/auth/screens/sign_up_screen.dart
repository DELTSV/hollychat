import 'package:flutter/material.dart';
import 'package:hollychat/auth/widgets/auth_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
          child: Column(
            children: [
              Image(image: AssetImage('assets/images/logo.png'), height: 30),
              Spacer(),
              AuthForm(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
