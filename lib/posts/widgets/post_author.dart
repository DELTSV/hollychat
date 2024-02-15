import 'package:flutter/material.dart';
import 'package:hollychat/models/author.dart';

class PostAuthor extends StatelessWidget {
  const PostAuthor({
    super.key,
    required this.author,
    required this.relativeTime,
  });

  final Author author;
  final String relativeTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        const SizedBox(width: 10),
        Text(
          relativeTime,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontStyle: FontStyle.italic,
          ),
          // makes text italic
        ),
      ],
    );
  }
}
