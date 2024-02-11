import 'dart:io';

import 'package:flutter/material.dart';

import 'image_button.dart';


// An horizontal list of images
class GalleryPreview extends StatelessWidget {
  const GalleryPreview({super.key, required this.imageList});

  final List<File> imageList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageList.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (BuildContext context, int index) {
          return ImageButton(image: imageList[index]);
        },
      ),
    );
  }
}
