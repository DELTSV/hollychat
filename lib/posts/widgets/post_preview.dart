import 'package:flutter/material.dart';
import 'package:hollychat/models/minimal_post.dart';
import 'package:hollychat/posts/widgets/post_author.dart';
import 'package:hollychat/posts/widgets/post_content.dart';

import 'image_viewer.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({
    super.key,
    required this.post,
    this.onTap,
  });

  final MinimalPost post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostAuthor(author: post.author),
            const SizedBox(height: 10),
            PostContent(content: post.content, image: post.image),
          ],
        ),
      ),
    );
  }
}
