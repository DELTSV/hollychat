import 'package:flutter/material.dart';

class AlertError extends StatelessWidget {
  const AlertError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.error, color: Colors.redAccent),
        const SizedBox(width: 10),
        Text(message),
      ],
    );
  }
}
