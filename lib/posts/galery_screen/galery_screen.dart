import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageGalleryScreen extends StatefulWidget {
  static const String routeName = "/gallery";

  const ImageGalleryScreen({super.key});

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  List<File>? _imageList;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final bool isPermissionGranted = await _requestPermission();
    if (isPermissionGranted) {
      // Permission granted, load images
      _loadImages();
    }
  }

  Future<bool> _requestPermission() async {
    try {
      // Checking permission

      // Invoke method and wait for result
       bool? test = await const MethodChannel('permissions')
          .invokeMethod<bool>('requestStoragePermission');

       if (test != null && test) {
         // Permission already granted
         return true;
       } else {
         // Permission denied, waiting for user

         const MethodChannel('permissions')
             .setMethodCallHandler((call) async {
           if (call.method == 'onRequestPermissionsResult') {

             final bool? isPermissionGranted = call.arguments;

             if (isPermissionGranted != null && isPermissionGranted) {
               // Permission granted from handler
               _loadImages();
             } else {
               // Permission denied from handler
               Navigator.of(context).pop();
             }
           }
         });

         return false;
       }
    } on PlatformException catch (e) {
      // Handle platform exceptions
      print('Error requesting permission: $e');
      return false;
    }
  }

  Future<void> _loadImages() async {
    try {
      final MethodChannel _channel = MethodChannel('image_gallery');
      final List<dynamic>? result =
      await _channel.invokeMethod<List<dynamic>>('getImages');

      if (result != null) {
        print("Result: $result");
        setState(() {
          _imageList = result.map((path) => File(path)).toList();
        });
      }
    } on PlatformException catch (e) {
      print("Failed to load images: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Gallery'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _loadImages,
          child: const Icon(Icons.photo_library),
        ),
        body: _imageList == null
            ? const Center(
          child: Text('No images selected'),
        )
            : GridView.builder(
          itemCount: _imageList!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Adjust the number of columns as needed
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Image.file(
              _imageList![index],
              fit: BoxFit.cover,
            );
          },
        ));
  }
}
