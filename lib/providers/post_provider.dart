import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../services/post_service.dart';

class PostProvider with ChangeNotifier {
  final PostService _postService = PostService();

  List<PostModel> _posts = [];
  List<PostModel> _friendsPosts = [];
  List<PostModel> _userPosts = [];
  bool _isLoading = false;
  String? _error;

  List<PostModel> get posts => _posts;
  List<PostModel> get friendsPosts => _friendsPosts;
  List<PostModel> get userPosts => _userPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAllPosts() async {
    try {
      _isLoading = true;
      notifyListeners();

      _posts = await _postService.getAllPosts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFriendsPosts(List<String> friendIds) async {
    try {
      _isLoading = true;
      notifyListeners();

      _friendsPosts = await _postService.getFriendsPosts(friendIds);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserPosts(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _userPosts = await _postService.getUserPosts(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPost(PostModel post) async {
    try {
      _isLoading = true;
      notifyListeners();

      final success = await _postService.createPost(post);
      if (success) {
        _posts.insert(0, post);
        _userPosts.insert(0, post);
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      await _postService.likePost(postId, userId);

      // Update local state
      _updatePostInList(_posts, postId, userId, true);
      _updatePostInList(_friendsPosts, postId, userId, true);
      _updatePostInList(_userPosts, postId, userId, true);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _postService.unlikePost(postId, userId);

      // Update local state
      _updatePostInList(_posts, postId, userId, false);
      _updatePostInList(_friendsPosts, postId, userId, false);
      _updatePostInList(_userPosts, postId, userId, false);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _updatePostInList(List<PostModel> list, String postId, String userId, bool isLike) {
    final index = list.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      final post = list[index];
      final updatedLikes = List<String>.from(post.likes);

      if (isLike) {
        if (!updatedLikes.contains(userId)) {
          updatedLikes.add(userId);
        }
      } else {
        updatedLikes.remove(userId);
      }

      list[index] = post.copyWith(likes: updatedLikes);
    }
  }

  Future<List<CommentModel>> getComments(String postId) async {
    try {
      return await _postService.getComments(postId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<bool> addComment(CommentModel comment) async {
    try {
      final success = await _postService.addComment(comment);
      if (success) {
        // Update comment count
        _incrementCommentCount(_posts, comment.postId);
        _incrementCommentCount(_friendsPosts, comment.postId);
        _incrementCommentCount(_userPosts, comment.postId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _incrementCommentCount(List<PostModel> list, String postId) {
    final index = list.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      final post = list[index];
      list[index] = post.copyWith(commentCount: post.commentCount + 1);
    }
  }
}
