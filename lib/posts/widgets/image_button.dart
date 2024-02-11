import 'dart:io';

import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({super.key, required this.image});

  final File image;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      image,
      width: 100,
      fit: BoxFit.cover,
    );
  }
}
