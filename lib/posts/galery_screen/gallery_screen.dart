import 'dart:io';

import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  static const String routeName = "/gallery";

  const GalleryScreen({super.key, required this.imageList});

  static void navigateTo(BuildContext context, List<File> imageList) {
    Navigator.of(context).pushNamed(routeName, arguments: imageList);
  }

  final List<File> imageList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
      ),
      body: GridView.builder(
        itemCount: imageList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Adjust the number of columns as needed
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Image.file(
            imageList[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
