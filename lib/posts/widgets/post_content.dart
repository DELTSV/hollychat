import 'package:flutter/material.dart';
import 'package:hollychat/models/post_image.dart';
import 'package:hollychat/posts/widgets/link_message.dart';
import 'package:hollychat/posts/widgets/post_link_preview.dart';

import 'image_viewer.dart';

class PostContent extends StatelessWidget {
  const PostContent(
      {super.key, required this.content, this.image, required this.linkImages, required this.links});

  final List<String> content;
  final PostImage? image;
  final List<PostImage> linkImages;
  final List<String> links;

  @override
  Widget build(BuildContext context) {

    if(content.isEmpty && linkImages.isNotEmpty) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ...linkImages.map((img) =>
                ImageViewer(
                  postImage: img,
                )),
            if (image != null) ...[
              const SizedBox(height: 10),
              ImageViewer(
                postImage: image!,
              ),
            ],
          ],
      );
    }

    var spans = content.getRange(1, content.length).map((text) =>
    text.startsWith("http") ?
    linkMessage(text, null):
    TextSpan(text: text)
    ).toList();

    var rootSpan = content[0].startsWith("http") ?
    linkMessage(content[0], spans) :
    TextSpan(text: content[0], children: spans);

    var previews = links.map((e) => PostLinkPreview(url: e));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: rootSpan
        ),
        ...linkImages.map((img) =>
            ImageViewer(
              postImage: img,
            )),
        if (image != null) ...[
          const SizedBox(height: 10),
          ImageViewer(
            postImage: image!,
          ),
        ],
        ...previews,
      ],
    );
  }
}
