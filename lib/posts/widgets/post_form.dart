import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'gallery_preview.dart';

class PostForm extends StatefulWidget {
  const PostForm({
    super.key,
    required this.onContentChanged,
    required this.onImageSelected,
    required this.defaultContent,
    required this.defaultImage,
  });

  final String defaultContent;
  final File? defaultImage;

  final void Function(String content) onContentChanged;
  final void Function(File? image) onImageSelected;

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  List<File>? _imageList;
  File? _imageSelected;
  String _content = "";

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.defaultImage != null) {
      _imageSelected = widget.defaultImage;

      // WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   widget.onImageSelected(_imageSelected);
      // });
    }

    if (widget.defaultContent.isNotEmpty) {
      _content = widget.defaultContent;
      _controller.text = widget.defaultContent;
    }

    _controller.addListener(() {
      _onPostTextChanged(_controller.text);
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      _checkImagesPermission();
    });
  }

  void selectImage(File? image) {
    setState(() {
      _imageSelected = image;
    });

    widget.onImageSelected(image);
  }

  void resetImage() {
    selectImage(null);
  }

  void _onImageSelected(File image) {
    if (_imageSelected == image) {
      resetImage();
      return;
    }

    selectImage(image);
  }

  _onGalleryTap() {
    ImagePicker imagePicker = ImagePicker();

    imagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        selectImage(File(image.path));
      }
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

  _onCameraTap() async {
    ImagePicker imagePicker = ImagePicker();

    if (await _checkCameraPermission() == false) {
      return;
    }

    imagePicker.pickImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        selectImage(File(image.path));
      }
    });
  }

  _onPostTextChanged(String value) {
    setState(() {
      _content = value;
    });

    widget.onContentChanged(value);
  }

  _checkImagesPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      _loadImages();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
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

  _buildImage() {
    if (_imageSelected == null) {
      return const SizedBox();
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            _imageSelected!,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              resetImage();
            },
            child: IconButton(
              icon: const Icon(
                Icons.cancel,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => setState(() {
                resetImage();
              }),
            ),
          ),
        ),
      ],
    );
  }

  _buildGallery() {
    if (_imageList == null) {
      return const SizedBox();
    }

    return GalleryPreview(
      imageList: _imageList ?? [],
      onImageSelected: _onImageSelected,
      onCameraTap: _onCameraTap,
      onGalleryTap: _onGalleryTap,
      imageSelected: _imageSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _controller,
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
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _buildImage(),
        ),
        const SizedBox(height: 20),
        _buildGallery(),
      ],
    );
  }
}
