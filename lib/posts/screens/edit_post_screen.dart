import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hollychat/models/minimal_post.dart';
import 'package:hollychat/posts/widgets/post_form.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key, required this.post});

  final MinimalPost post;

  static const String routeName = "/edit-post";

  static void navigateTo(BuildContext context, MinimalPost post) {
    Navigator.of(context).pushNamed(routeName, arguments: post);
  }

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  File? _imageSelected;
  String _content = "";

  String _defaultContent = "";
  File? _defaultImage;

  bool canDisplayForm = false;

  @override
  void initState() {
    super.initState();
    _defaultContent = widget.post.content;
    if (widget.post.image != null) {
      urlToFile(widget.post.image?.url ?? "").then(
        (value) => setState(() {
          _defaultImage = value;
          canDisplayForm = true;
        }),
      );
    } else {
      canDisplayForm = true;
    }
  }

  Future<File> urlToFile(String imageUrl) async {
    final http.Response responseData = await http.get(
      Uri.parse(imageUrl),
    );
    Uint8List uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/img').writeAsBytes(
      buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );

    return file;
  }

  _editPost() {
    if (_canEditPost()) {
      print("object");
    }
  }

  _getEditButton() {
    bool canEdit = _canEditPost();

    return IconButton(
      onPressed: canEdit ? _editPost : null,
      icon: Icon(
        Icons.edit,
        color: canEdit ? Colors.white : Colors.grey[600],
      ),
    );
  }

  _getPostForm() {
    if (canDisplayForm) {
      return PostForm(
        defaultContent: _defaultContent,
        defaultImage: _defaultImage,
        onContentChanged: (content) {
          setState(() {
            _content = content;
          });
        },
        onImageSelected: (image) {
          setState(() {
            _imageSelected = image;
          });
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  _canEditPost() {
    bool contentChanged = _content != _defaultContent;
    bool imageChanged = _imageSelected != _defaultImage;
    return _content.isNotEmpty && (contentChanged || imageChanged);
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
        actions: [_getEditButton()],
        title: Text(
          'Editer le post',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: _getPostForm(),
        ),
      ),
    );
  }
}
