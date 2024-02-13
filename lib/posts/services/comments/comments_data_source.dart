import 'package:hollychat/models/full_post.dart';

import '../../../models/minimal_post.dart';

abstract class CommentsDataSource {
  Future<void> createComment(int postId, String content);
}
