import 'package:flutter/material.dart';
import 'package:hollychat/models/post_comment.dart';
import 'package:hollychat/posts/widgets/post_author.dart';
import 'package:hollychat/posts/widgets/settings_menu.dart';

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
        onEdit(comment.content);
        break;
      case MenuItemType.delete:
        onDelete();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              SettingsMenu(
                onItemSelected: (itemType) =>
                    _onItemSelected(itemType, context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
