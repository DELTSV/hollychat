import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/models/post_comment.dart';
import 'package:hollychat/models/user.dart';
import 'package:hollychat/posts/widgets/post_author.dart';
import 'package:hollychat/posts/widgets/post_link_preview.dart';
import 'package:hollychat/posts/widgets/settings_menu.dart';

import 'image_viewer.dart';
import 'link_message.dart';

class PostCommentPreview extends StatelessWidget {
  const PostCommentPreview({
    super.key,
    required this.comment,
    required this.onDelete,
    required this.onEdit,
  });

  final PostComment comment;

  final Function() onDelete;
  final Function(String) onEdit;

  void _onItemSelected(MenuItemType value, BuildContext context) {
    switch (value) {
      case MenuItemType.edit:
        onEdit(comment.originalString);
        break;
      case MenuItemType.delete:
        onDelete();
        break;
    }
  }

  bool _isAuthor(User? user, PostComment author) {
    return user?.id == author.author.id;
  }

  @override
  Widget build(BuildContext context) {
    if(comment.content.isEmpty && comment.imagesLinks.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostAuthor(author: comment.author),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (_isAuthor(state.user, comment)) {
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
                ...comment.imagesLinks.map((img) =>
                    ImageViewer(
                      postImage: img,
                    )),
              ],
            )
          ],
        ),
      );
    }

    var spans = comment.content.getRange(1, comment.content.length).map((text) =>
    text.startsWith("http") ?
    linkMessage(text, null):
    TextSpan(text: text, style: const TextStyle(color: Colors.white, decoration: TextDecoration.none))
    ).toList();

    var rootSpan = comment.content[0].startsWith("http") ?
    linkMessage(comment.content[0], spans) :
    TextSpan(text: comment.content[0], style: const TextStyle(color: Colors.white, decoration: TextDecoration.none), children: spans);

    var previews = comment.linksPreviews.map((e) => PostLinkPreview(linkPreview: e,));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PostAuthor(author: comment.author),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (_isAuthor(state.user, comment)) {
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
              RichText(
                  text: rootSpan
              ),
              ...comment.imagesLinks.map((img) =>
                  ImageViewer(
                    postImage: img,
                  )),
              ...previews
            ],
          )
        ],
      ),
    );
  }
}
