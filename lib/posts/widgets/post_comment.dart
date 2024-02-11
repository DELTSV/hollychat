import 'package:flutter/material.dart';
import 'package:hollychat/models/post_comment.dart';
import 'package:hollychat/posts/widgets/post_author.dart';

class PostCommentPreview extends StatelessWidget {
  const PostCommentPreview({super.key, required this.comment});

  final PostComment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostAuthor(author: comment.author),
          const SizedBox(height: 10),
          Text(
            comment.content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
