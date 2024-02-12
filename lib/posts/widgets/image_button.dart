import 'dart:io';

import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  const ImageButton({super.key, required this.image});

  final File image;

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  bool isImageLoaded = false;

  @override
  Widget build(BuildContext context) {
    Image imageWidget = Image.file(
      widget.image,
      width: 100,
      fit: BoxFit.cover,
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

    return AnimatedOpacity(
      opacity: isImageLoaded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Stack(children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: imageWidget,
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onTap: () => {},
            ),
          ),
        ),
      ]),
    );
  }
}
