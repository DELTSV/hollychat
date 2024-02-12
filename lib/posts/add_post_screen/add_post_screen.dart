import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/gallery_preview.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  static const String routeName = "/new-post";

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<File>? _imageList;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      _checkImagesPermission();
    });
  }

  Future<bool> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      return openAppSettings().then((value) => value);
    }

    return false;
  }

  _checkImagesPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      _loadImages();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  _onGalleryTap() {
    ImagePicker imagePicker = ImagePicker();

    imagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          _imageList = [File(image.path)];
        });
      }
    });
  }

  _onCameraTap() async {
    ImagePicker imagePicker = ImagePicker();

    if (await _checkCameraPermission() == false) {
      return;
    }

    imagePicker.pickImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        setState(() {
          _imageList = [File(image.path)];
        });
      }
    });
  }

  Future<void> _loadImages() async {
    try {
      const MethodChannel _channel = MethodChannel('image_gallery');
      // Pass the count argument to the platform method
      final List<dynamic>? result = await _channel.invokeMethod<List<dynamic>>(
        'getImages',
        <String, dynamic>{'count': 8},
      );

      if (result != null) {
        setState(() {
          _imageList = result.map((path) => File(path)).toList();
        });
      }
    } on PlatformException catch (e) {
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
        ],
        title: Text(
          'Nouveau post',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  autofocus: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Quoi de neuf mon reuf ?',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // add a button to navigate to the gallery
                const SizedBox(height: 20),
                Builder(builder: (context) {
                  if (_imageList == null) {
                    return const SizedBox();
                  }

                  return GalleryPreview(
                    imageList: _imageList ?? [],
                    onImageSelected: (image) {
                      // do something with the image
                    },
                    onCameraTap: _onCameraTap,
                    onGalleryTap: _onGalleryTap,
                  );
                })
              ],
            )),
      ),
    );
  }
}
