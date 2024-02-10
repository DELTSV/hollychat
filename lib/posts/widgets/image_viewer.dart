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

        final imageWidget = Image.network(
          widget.postImage.url,
          height: height,
          width: width,
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return AnimatedOpacity(
                opacity: isImageLoaded ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200), // Adjust as needed
                child: child,
              );
            }

            final loadProgressValue = loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null;

            return SizedBox(
              height: height,
              width: width,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadProgressValue,
                ),
              ),
            );
          },
        );

        if (!isImageLoaded) {
          imageWidget.image.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener(
              (ImageInfo image, bool synchronousCall) {
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => setState(() {
                      isImageLoaded = true;
                    }),
                  );
                }
              },
            ),
          );
        }

        return imageWidget;
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
