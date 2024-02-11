import 'package:flutter/material.dart';
import 'package:hollychat/models/author.dart';

class PostAuthor extends StatelessWidget {
  const PostAuthor({super.key, required this.author});

  final Author author;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              'https://api.dicebear.com/7.x/personas/png?seed=${author.id}'),
        ),
        const SizedBox(width: 10),
        Text(
          author.username,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
