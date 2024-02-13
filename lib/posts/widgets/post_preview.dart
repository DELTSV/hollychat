import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/models/author.dart';
import 'package:hollychat/models/minimal_post.dart';
import 'package:hollychat/posts/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:hollychat/posts/widgets/delete_alert_dialog.dart';
import 'package:hollychat/posts/widgets/post_author.dart';
import 'package:hollychat/posts/widgets/post_content.dart';
import 'package:hollychat/posts/widgets/post_settings_menu.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../models/user.dart';
import '../screens/edit_post_screen.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({
    super.key,
    required this.post,
    this.onTap,
  });

  final MinimalPost post;
  final VoidCallback? onTap;

  _onItemSelected(MenuItemType value, BuildContext context) {
    switch (value) {
      case MenuItemType.edit:
        EditPostScreen.navigateTo(context, post);
        break;
      case MenuItemType.delete:
        showAlertDialog(context);
        break;
    }
  }

  _onDeletePost(BuildContext context) {
    BlocProvider.of<DeletePostBloc>(context).add(
      DeletePost(
        id: post.id,
      ),
    );
  }

  void _onPostDeleted(BuildContext context) {
    Navigator.of(context).pop();
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAlertDialog(
          onDeletePost: () => _onDeletePost(context),
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  _getPostHeader(BuildContext context, bool isAuthor) {
    if (!isAuthor) {
      return PostAuthor(author: post.author);
    }

    return BlocListener<DeletePostBloc, DeletePostState>(
      listener: (context, state) {
        if (state.status == DeletePostStatus.success) {
          _onPostDeleted(context);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PostAuthor(author: post.author),
          PostSettingsMenu(
            onItemSelected: (itemType) => _onItemSelected(itemType, context),
          ),
        ],
      ),
    );
  }

  _compareUserAuthor(User? user, Author author) {
    if (user == null) {
      return false;
    }

    return user.id == post.author.id;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getPostHeader(
                context,
                _compareUserAuthor(state.user, post.author),
              ),
              const SizedBox(height: 10),
              PostContent(content: post.content, image: post.image),
            ],
          );
        }),
      ),
    );
  }
}
