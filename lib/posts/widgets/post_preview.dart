import 'package:flutter/material.dart';

import '../../models/post.dart';
import 'insta_image_viewer.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        // Display the post header with profile picture and username
        // Also display the post body with an optional image
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the post header with profile picture and username
            // Also display the post body with an optional image
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://api.dicebear.com/7.x/personas/png?seed=${post.author.id}'),
                ),
                const SizedBox(width: 10),
                Text(
                  post.author.username,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (post.image != null) ...[
              const SizedBox(height: 10),
              InstaImageViewer(
                child: Image.network(post.image!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
