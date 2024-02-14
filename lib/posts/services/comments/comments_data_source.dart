import 'package:hollychat/models/full_post.dart';

import '../../../models/minimal_post.dart';

abstract class CommentsDataSource {
  Future<void> createComment(int postId, String content);
  Future<void> updateComment(int commentId, String content);
  Future<void> deleteComment(int commentId);
}
