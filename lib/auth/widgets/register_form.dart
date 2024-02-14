import 'package:flutter/material.dart';
import 'package:hollychat/auth/widgets/password_field.dart';
import 'package:hollychat/auth/widgets/username_field.dart';

import 'email_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  final bool isLoading;
  final void Function(String email, String userName, String password) onSubmit;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String? _errorText;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleFormSubmit() {
    if (_canSubmit()) {
      widget.onSubmit(
        _emailController.text,
        _usernameController.text,
        _passwordController.text,
      );
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
    return Card(
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
              UsernameField(
                controller: _usernameController,
                errorText: _errorText,
              ),
              PasswordField(
                controller: _passwordController,
                errorText: _errorText,
                checkLength: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: widget.isLoading ? null : _handleFormSubmit,
                child: const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
