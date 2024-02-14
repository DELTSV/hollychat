import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
    required this.controller,
    this.errorText,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: const [AutofillHints.email],
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Nom d'utilisateur",
        hintText: "Nom d'utilisateur",
        helperText: "Enter votre nom d'utilisateur",
        errorText: errorText,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return "Le nom d'utilisateur ne peut pas être vide";
        }
        return null;
      },
      controller: controller,
    );
  }
}
