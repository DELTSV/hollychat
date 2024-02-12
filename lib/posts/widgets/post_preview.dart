import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollychat/models/author.dart';
import 'package:hollychat/models/minimal_post.dart';
import 'package:hollychat/posts/bloc/delete_post_bloc/delete_post_bloc.dart';
import 'package:hollychat/posts/widgets/delete_alert_dialog.dart';
import 'package:hollychat/posts/widgets/post_author.dart';
import 'package:hollychat/posts/widgets/post_content.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../models/user.dart';

class MenuItem {
  const MenuItem({
    required this.type,
    required this.content,
  });

  final MenuItemType type;
  final Widget content;
}

enum MenuItemType {
  edit,
  delete,
}

class PostPreview extends StatelessWidget {
  const PostPreview({
    super.key,
    required this.post,
    this.onTap,
  });

  final MinimalPost post;
  final VoidCallback? onTap;

  List<PopupMenuItem<MenuItemType>> _buildItems() {
    const List<MenuItem> items = [
      MenuItem(
        type: MenuItemType.edit,
        content: Row(
          children: [
            Icon(Icons.edit),
            SizedBox(width: 10),
            Text('Éditer'),
          ],
        ),
      ),
      MenuItem(
        type: MenuItemType.delete,
        content: Row(
          children: [
            Icon(Icons.delete, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
          ],
        ),
      ),
    ];

    return items
        .map(
          (MenuItem item) => PopupMenuItem<MenuItemType>(
            value: item.type,
            child: item.content,
          ),
        )
        .toList();
  }

  _onItemSelected(MenuItemType value, BuildContext context) {
    switch (value) {
      case MenuItemType.edit:
        break;
      case MenuItemType.delete:
        showAlertDialog(context);
        break;
    }
  }

  _onDeletePost(BuildContext context) {
    BlocProvider.of<DeletePostBloc>(context).add(DeletePost(
      id: post.id,
    ));
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
          PopupMenuButton<MenuItemType>(
            iconColor: Colors.white,
            onSelected: (MenuItemType value) => _onItemSelected(
              value,
              context,
            ),
            itemBuilder: (BuildContext context) {
              return _buildItems();
            },
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
