import 'package:flutter/material.dart';
import 'package:hollychat/models/post_comment.dart';
import 'package:hollychat/posts/widgets/post_comment.dart';
import 'package:hollychat/posts/widgets/post_separator.dart';

class PostCommentList extends StatelessWidget {
  const PostCommentList({
    super.key,
    required this.comments,
    required this.onDelete,
    required this.onEdit,
  });

  final List<PostComment> comments;

  final Function(int id) onDelete;
  final Function(int id, String content) onEdit;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return Center(
        child: Text(
          'Aucun commentaire trouvé pour ce post.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return Column(
      children: [
        ...comments.map(
          (comment) => Column(
            children: [
              PostCommentPreview(
                comment: comment,
                onDelete: () => onDelete(comment.id),
                onEdit: (content) => onEdit(comment.id, content),
              ),
              const PostSeparator(
                padding: 10,
              ),
            ],
          ),
        ),
        Center(
          child: Text(
            'Aucun autre commentaire trouvé.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
