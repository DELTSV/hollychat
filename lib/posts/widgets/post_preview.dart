import 'package:flutter/material.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({super.key, required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
              child: Text(
            body,
            textAlign: TextAlign.justify,
          ))),
    );
  }
}
