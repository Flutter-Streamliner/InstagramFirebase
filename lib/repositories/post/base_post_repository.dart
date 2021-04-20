import 'package:flutter_instagram/models/models.dart';
import 'package:meta/meta.dart';

abstract class BasePostRepository {
  Future<void> createPost({@required Post post});
  Future<void> createComment({@required Comment comment});
  Stream<List<Future<Post>>> getUserPosts({@required String userId});
  Stream<List<Future<Comment>>> getPostComments({@required String postId});
}