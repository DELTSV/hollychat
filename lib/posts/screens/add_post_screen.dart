import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/posts/widgets/post_form.dart';

import '../bloc/add_post_bloc/add_post_bloc.dart';

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
  File? _imageSelected;
  String _content = "";

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
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: PostForm(
                  defaultContent: "",
                  defaultImage: null,
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
