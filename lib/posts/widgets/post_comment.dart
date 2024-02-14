import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/auth/bloc/auth_bloc.dart';
import 'package:hollychat/models/post_comment.dart';
import 'package:hollychat/models/user.dart';
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

  bool _isAuthor(User? user, PostComment author) {
    return user?.id == author.author.id;
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
          Text(
            comment.content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
