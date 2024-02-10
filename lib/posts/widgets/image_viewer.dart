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
                duration: const Duration(milliseconds: 500), // Adjust as needed
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

class FadeInImageAnimation extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final Duration duration;

  const FadeInImageAnimation({
    required this.imageUrl,
    required this.width,
    required this.height,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  _FadeInImageAnimationState createState() => _FadeInImageAnimationState();
}

class _FadeInImageAnimationState extends State<FadeInImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Image.network(
            widget.imageUrl,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
