import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/auth/widgets/password_field.dart';

import 'email_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  final bool isLoading;
  final void Function(String email, String password) onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? _errorText;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleFormSubmit() {
    if (_canSubmit()) {
      widget.onSubmit(_emailController.text, _passwordController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez corriger les erreurs dans le formulaire"),
        ),
      );
    }
  }

  bool _canSubmit() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          setState(() {
            _errorText = "Email ou mot de passe incorrect";
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email ou mot de passe incorrect"),
            ),
          );
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                _errorText = null;
              });
            },
            child: Column(
              children: [
                EmailField(
                  controller: _emailController,
                  errorText: _errorText,
                ),
                PasswordField(
                  controller: _passwordController,
                  errorText: _errorText,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: widget.isLoading ? null : _handleFormSubmit,
                  child: const Text("Se connecter"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
