import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hollychat/models/post_image.dart';

import '../image_screen/image_screen.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({
    super.key,
    required this.postImage,
  });

  final PostImage postImage;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool isImageLoaded = false;

  @override
  Widget build(BuildContext context) {
    final UniqueKey tag = UniqueKey();

    final image = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        final aspectRatio = widget.postImage.width / widget.postImage.height;

        final height = width / aspectRatio;

        return Image.network(
          widget.postImage.url,
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

            // check if the image is loaded
            if (loadingProgress.cumulativeBytesLoaded ==
                loadingProgress.expectedTotalBytes) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => setState(() {
                  isImageLoaded = true;
                }),
              );
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
          Builder(builder: (context) {
            if (!isImageLoaded) {
              return const SizedBox();
            }

            return Positioned.fill(
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
            );
          }),
        ],
      ),
    );
  }
}
