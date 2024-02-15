import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/models/post_comment.dart';
import 'package:hollychat/models/user.dart';
import 'package:hollychat/posts/bloc/comment_bloc/comment_bloc.dart';
import 'package:hollychat/posts/widgets/post_author.dart';
import 'package:hollychat/posts/widgets/post_link_preview.dart';
import 'package:hollychat/posts/widgets/settings_menu.dart';

import 'image_viewer.dart';
import 'link_message.dart';

class PostCommentPreview extends StatefulWidget {
  const PostCommentPreview({
    super.key,
    required this.comment,
    required this.onDelete,
    required this.onEdit,
  });

  final PostComment comment;

  final Function() onDelete;
  final Function(String) onEdit;

  @override
  State<PostCommentPreview> createState() => _PostCommentPreviewState();
}

class _PostCommentPreviewState extends State<PostCommentPreview> {
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();
  String _commentContent = "";

  @override
  void initState() {
    super.initState();
    _controller.text = widget.comment.originalString;

    _controller.addListener(() {
      setState(() {
        _commentContent = _controller.text;
      });
    });
  }

  void _onItemSelected(MenuItemType value, BuildContext context) {
    switch (value) {
      case MenuItemType.edit:
        _onTriggerEdit();
        break;
      case MenuItemType.delete:
        widget.onDelete();
        break;
    }
  }

  void _onTriggerEdit() {
    setState(() {
      _isEditing = true;
    });
  }

  bool _isAuthor(User? user, PostComment author) {
    return user?.id == author.author.id;
  }

  _getCommentContent() {
    if (_isEditing) {
      return Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            setState(() {
              _isEditing = false;
            });
          }
        },
        child: TextField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          autocorrect: true,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Edit comment',
            hintStyle: TextStyle(
              color: Colors.grey[500],
            ),
            suffixIcon: BlocBuilder<CommentBloc, CommentState>(
              builder: (context, state) {
                bool canSubmit = _commentContent.isNotEmpty &&
                    state.status != CommentStatus.loading;

                return IconButton(
                  icon: Icon(
                    Icons.save,
                    color: canSubmit ? Colors.white : Colors.grey[600],
                  ),
                  onPressed:
                      canSubmit ? () => widget.onEdit(_controller.text) : null,
                );
              },
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          autofocus: true,
        ),
      );
    }

    var spans = widget.comment.content
        .getRange(1, widget.comment.content.length)
        .map((text) => text.startsWith("http")
            ? linkMessage(text, null)
            : TextSpan(
                text: text,
                style: const TextStyle(
                    color: Colors.white, decoration: TextDecoration.none)))
        .toList();

    var rootSpan = widget.comment.content[0].startsWith("http")
        ? linkMessage(widget.comment.content[0], spans)
        : TextSpan(
            text: widget.comment.content[0],
            style: const TextStyle(
                color: Colors.white, decoration: TextDecoration.none),
            children: spans);

    var previews = widget.comment.linksPreviews.map((e) => PostLinkPreview(
          linkPreview: e,
        ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(text: rootSpan),
        ...widget.comment.imagesLinks.map((img) => ImageViewer(
              postImage: img,
            )),
        ...previews
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.comment.content.isEmpty &&
        widget.comment.imagesLinks.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostAuthor(author: widget.comment.author),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (_isAuthor(state.user, widget.comment)) {
                      return SettingsMenu(
                        onItemSelected: (itemType) =>
                            _onItemSelected(itemType, context),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ...widget.comment.imagesLinks.map((img) => ImageViewer(
                      postImage: img,
                    )),
              ],
            )
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PostAuthor(author: widget.comment.author),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (_isAuthor(state.user, widget.comment)) {
                    return SettingsMenu(
                      onItemSelected: _isEditing
                          ? null
                          : (itemType) => _onItemSelected(itemType, context),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          _getCommentContent(),
        ],
      ),
    );
  }
}
