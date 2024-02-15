import 'package:flutter/material.dart';

class AlertSuccess extends StatelessWidget {
  const AlertSuccess({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.greenAccent),
        const SizedBox(width: 10),
        Text(message),
      ],
    );
  }
}
