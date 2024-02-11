import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/models/auth.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 300, width: 400),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Email"),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The email cannot be empty.";
                    }
                    return null;
                  },
                  controller: _emailController,
                ),
                const Spacer(),
                const Text("Password"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: handleFormSubmit,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleFormSubmit() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(Login(
      email: _emailController.text,
      password: _passwordController.text,
    ));
    Navigator.pop(context);
  }
}
