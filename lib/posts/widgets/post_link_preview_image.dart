import 'package:flutter/material.dart';

class PostLinkPreviewImage extends StatelessWidget {
  const PostLinkPreviewImage({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return const SizedBox();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        imageUrl!,
        errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
        ) =>
            const Icon(Icons.error),
      height: 60,
    ));
  }
}
