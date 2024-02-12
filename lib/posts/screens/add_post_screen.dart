import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/add_post_bloc/add_post_bloc.dart';
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

  File? _imageSelected;
  String _content = "";

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
        selectImage(File(image.path));
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
        selectImage(File(image.path));
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

  void selectImage(File? image) {
    setState(() {
      _imageSelected = image;
    });
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

  _onSendPost() {
    if (!canSendPost()) {
      return;
    }

    final postsBloc = BlocProvider.of<AddPostBloc>(context);
    postsBloc.add(AddNewPost(
      content: _content,
      imageBytes:
          _imageSelected != null ? _imageSelected!.readAsBytesSync() : [],
    ));
  }

  _onPostTextChanged(String value) {
    setState(() {
      _content = value;
    });
  }

  bool canSendPost() {
    return _content.isNotEmpty;
  }

  IconButton getSendButton() {
    bool canSend = canSendPost();

    return IconButton(
      onPressed: canSend ? _onSendPost : null,
      icon: Icon(
        Icons.send,
        color: canSend ? Colors.white : Colors.grey[600],
      ),
    );
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
        actions: [getSendButton()],
        title: Text(
          'Nouveau post',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: BlocListener<AddPostBloc, AddPostState>(
        listener: (context, state) {
          if (state.status == AddPostStatus.success) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<AddPostBloc, AddPostState>(
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.multiline,
                        autocorrect: true,
                        autofocus: true,
                        maxLines: null,
                        onChanged: _onPostTextChanged,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Quoi de neuf mon reuf ?',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      Builder(builder: (context) {
                        if (_imageSelected == null) {
                          return const SizedBox();
                        }

                        return Expanded(
                          child: Stack(
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
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      Builder(builder: (context) {
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
                      })
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
