import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.errorText,
    required this.passwordController,
  });

  final String? errorText;
  final bool checkLength = false;
  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = false;

  void _onSwitchPasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: "Mot de passe",
        hintText: "Mot de passe",
        helperText: "Entrer votre mot de passe",
        errorText: widget.errorText,
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: _onSwitchPasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Le mot de passe ne peut pas être vide";
        }

        if (value.length < 8 && widget.checkLength) {
          return "Le mot de passe doit contenir au moins 8 caractères";
        }

        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.passwordController,
      obscureText: !_passwordVisible,
    );
  }
}
