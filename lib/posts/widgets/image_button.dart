import 'dart:io';

import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  const ImageButton(
      {super.key,
      required this.image,
      this.selected = false,
      required this.onTap});

  final File image;
  final bool selected;
  final void Function() onTap;

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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: widget.selected ? Colors.white : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: imageWidget,
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onTap: widget.onTap,
            ),
          ),
        ),
      ]),
    );
  }
}
