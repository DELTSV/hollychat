import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hollychat/models/post_image.dart';

import '../image_screen/image_screen.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.postImage,
  });

  final PostImage postImage;

  @override
  Widget build(BuildContext context) {
    final UniqueKey tag = UniqueKey();

    final image = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        final aspectRatio = postImage.width / postImage.height;

        final height = width / aspectRatio;

        return Image.network(
          postImage.url,
          height: height,
          width: width,
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return SizedBox(
              height: height,
              width: width,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        );
      },
    );

    return Hero(
      tag: tag,
      child: Stack(
        children: <Widget>[
          image,
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 200)).then(
                    (_) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          barrierColor: Colors.white.withOpacity(0),
                          pageBuilder: (BuildContext context, _, __) {
                            return ImageScreen(
                              tag: tag,
                              child: image,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
