import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/posts/widgets/post_form.dart';

import '../bloc/post_bloc/post_bloc.dart';
import '../widgets/linear_progress_bar.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  static const String routeName = "/new-post";

  static Route? createRoute(RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const AddPostScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

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

    final postsBloc = BlocProvider.of<PostBloc>(context);
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
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            bottom: LinearProgressBar(
              isLoading: state.status == PostStatus.loading,
            ),
            actions: [getSendButton()],
            title: Text(
              'Nouveau post',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if (state.status == PostStatus.success) {
                Navigator.of(context).pop();
              }
            },
            child: SafeArea(
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
            ),
          ),
        );
      },
    );
  }
}
