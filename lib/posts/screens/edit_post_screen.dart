import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/models/minimal_post.dart';
import 'package:hollychat/posts/widgets/post_form.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../bloc/post_bloc/post_bloc.dart';
import '../widgets/linear_progress_bar.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key, required this.post});

  final MinimalPost post;

  static const String routeName = "/edit-post";

  static Route? createRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    if (arguments is MinimalPost) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => EditPostScreen(
          post: arguments,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
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

    return null;
  }

  static void navigateTo(BuildContext context, MinimalPost post) {
    Navigator.of(context).pushNamed(routeName, arguments: post);
  }

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  File? _imageSelected;
  bool _imageUpdated = false;
  String _content = "";

  String _defaultContent = "";
  File? _defaultImage;

  bool canDisplayForm = false;

  @override
  void initState() {
    super.initState();
    _defaultContent = widget.post.originalText;
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
    if (!_canEditPost()) {
      return;
    }

    final postsBloc = BlocProvider.of<PostBloc>(context);
    postsBloc.add(
      UpdatePost(
        id: widget.post.id,
        content: _content,
        imageBytes:
            _imageSelected != null ? _imageSelected!.readAsBytesSync() : [],
      ),
    );
  }

  _getEditButton(bool isLoading) {
    bool canEdit = _canEditPost() && !isLoading;

    return IconButton(
      onPressed: canEdit ? _editPost : null,
      icon: Icon(
        Icons.save,
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
            _imageUpdated = true;
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
    return _content.isNotEmpty && (contentChanged || _imageUpdated);
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
            actions: [_getEditButton(state.status == PostStatus.loading)],
            title: Text(
              'Editer le post',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            bottom: LinearProgressBar(
              isLoading: state.status == PostStatus.loading,
            ),
          ),
          body: BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if (state.status == PostStatus.success) {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: _getPostForm(),
              ),
            ),
          ),
        );
      },
    );
  }
}
