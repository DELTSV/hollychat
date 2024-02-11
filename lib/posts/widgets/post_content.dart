import 'package:flutter/material.dart';
import 'package:hollychat/models/post_image.dart';

import 'image_viewer.dart';

class PostContent extends StatelessWidget {
  const PostContent({super.key, required this.content, this.image});

  final String content;
  final PostImage? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (image != null) ...[
          const SizedBox(height: 10),
          ImageViewer(
            postImage: image!,
          ),
        ],
      ],
    );
  }
}
