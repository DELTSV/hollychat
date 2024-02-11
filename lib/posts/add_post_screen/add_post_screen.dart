import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../galery_screen/gallery_screen.dart';
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

        const MethodChannel('permissions').setMethodCallHandler((call) async {
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
      return false;
    }
  }

  Future<void> _loadImages() async {
    try {
      const MethodChannel _channel = MethodChannel('image_gallery');
      final List<dynamic>? result =
          await _channel.invokeMethod<List<dynamic>>('getImages');

      if (result != null) {
        setState(() {
          List<File> files = result.map((path) => File(path)).toList();
          files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
          _imageList = files;
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
                GalleryPreview(
                  imageList: _imageList?.sublist(0, 10) ?? [],
                ),
                ElevatedButton(
                  onPressed: () {
                    GalleryScreen.navigateTo(context, _imageList ?? []);
                  },
                  child: const Text('Ajouter une image'),
                ),
              ],
            )),
      ),
    );
  }
}
