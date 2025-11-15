import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createPost(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.postId).set(post.toJson());
      return true;
    } catch (e) {
      throw Exception('Failed to create post: ${e.toString()}');
    }
  }

  Future<List<PostModel>> getAllPosts() async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get posts: ${e.toString()}');
    }
  }

  Future<List<PostModel>> getFriendsPosts(List<String> friendIds) async {
    try {
      if (friendIds.isEmpty) return [];

      final snapshot = await _firestore
          .collection('posts')
          .where('userId', whereIn: friendIds)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get friends posts: ${e.toString()}');
    }
  }

  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get user posts: ${e.toString()}');
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      throw Exception('Failed to like post: ${e.toString()}');
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      throw Exception('Failed to unlike post: ${e.toString()}');
    }
  }

  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: false)
          .get();

      return snapshot.docs.map((doc) => CommentModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get comments: ${e.toString()}');
    }
  }

  Future<bool> addComment(CommentModel comment) async {
    try {
      final batch = _firestore.batch();

      // Add comment to subcollection
      batch.set(
        _firestore
            .collection('posts')
            .doc(comment.postId)
            .collection('comments')
            .doc(comment.commentId),
        comment.toJson(),
      );

      // Increment comment count
      batch.update(_firestore.collection('posts').doc(comment.postId), {
        'commentCount': FieldValue.increment(1)
      });

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Failed to add comment: ${e.toString()}');
    }
  }

  Future<PostModel?> getPostById(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        return PostModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get post: ${e.toString()}');
    }
  }
}
