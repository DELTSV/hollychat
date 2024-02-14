import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  final bool isLoading;
  final void Function(String email, String password) onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String? _errorText;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;

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

  void _onSwitchPasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
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
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(height: 300, width: 400),
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
                  TextFormField(
                    autofillHints: const [AutofillHints.email],
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      helperText: "Enter votre email",
                      errorText: _errorText,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "L'email ne peut pas être vide";
                      }
                      return null;
                    },
                    controller: _emailController,
                  ),
                  const Spacer(),
                  TextFormField(
                    autofillHints: const [AutofillHints.password],
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      hintText: "Mot de passe",
                      helperText: "Entrer votre mot de passe",
                      errorText: _errorText,
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

                      // if (value.length < 8) {
                      //   return "Le mot de passe doit contenir au moins 8 caractères";
                      // }

                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: widget.isLoading ? null : _handleFormSubmit,
                    child: const Text("Se connecter"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
