
import '../../../models/full_post.dart';
import '../../../models/minimal_post.dart';
import 'comments_data_source.dart';

class CommentsRepository {
  final CommentsDataSource commentsDataSource;

  CommentsRepository({required this.commentsDataSource});

  Future<void> createComment(int postId, String content) async {
    return commentsDataSource.createComment(postId, content);
  }

  Future<void> updateComment(int commentId, String content) async {
    return commentsDataSource.updateComment(commentId, content);
  }

  Future<void> deleteComment(int commentId) async {
    return commentsDataSource.deleteComment(commentId);
  }
}
