import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hollychat/models/post_image.dart';
import 'package:hollychat/posts/widgets/link_message.dart';

import '../screens/image_screen.dart';

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
  bool displayBorder = false;

  void _onImageTap(BuildContext context, UniqueKey tag, PostImage post) {
    ImageScreen.navigateTo(context, tag, post);
  }

  @override
  Widget build(BuildContext context) {
    final UniqueKey tag = UniqueKey();

    final image = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double containerWidth = constraints.maxWidth;
        final aspectRatio = widget.postImage.width / widget.postImage.height;

        double height = containerWidth / aspectRatio;

        if (height > 300) {
          height = 300;
        }

        double width = height * aspectRatio;

        if (width < containerWidth && displayBorder == false) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => setState(() {
              displayBorder = true;
            }),
          );
        }

        final imageWidget = Image.network(
          widget.postImage.url,
          height: height,
          width: containerWidth,
          fit: BoxFit.contain,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return RichText(
              text: linkMessage(widget.postImage.url, null),
            );
          },
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
              width: containerWidth,
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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15.0),
        border: displayBorder
            ? Border.all(
                color: Colors.white.withAlpha(50),
                width: 0.5,
              )
            : null,
      ),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Hero(
              tag: tag,
              child: image,
            ),
          ),
          Builder(builder: (context) {
            if (!isImageLoaded) {
              return const SizedBox();
            }

            return Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 200)).then(
                      (_) => _onImageTap(context, tag, widget.postImage),
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
