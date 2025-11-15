import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }

  Future<bool> sendFriendRequest(String fromUserId, String toUserId) async {
    try {
      await _firestore.collection('users').doc(toUserId).update({
        'friendRequests': FieldValue.arrayUnion([fromUserId])
      });
      return true;
    } catch (e) {
      throw Exception('Failed to send friend request: ${e.toString()}');
    }
  }

  Future<bool> acceptFriendRequest(String userId, String friendId) async {
    try {
      final batch = _firestore.batch();

      // Add to both users' friends lists
      batch.update(_firestore.collection('users').doc(userId), {
        'friends': FieldValue.arrayUnion([friendId]),
        'friendRequests': FieldValue.arrayRemove([friendId])
      });

      batch.update(_firestore.collection('users').doc(friendId), {
        'friends': FieldValue.arrayUnion([userId])
      });

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Failed to accept friend request: ${e.toString()}');
    }
  }

  Future<bool> removeFriend(String userId, String friendId) async {
    try {
      final batch = _firestore.batch();

      batch.update(_firestore.collection('users').doc(userId), {
        'friends': FieldValue.arrayRemove([friendId])
      });

      batch.update(_firestore.collection('users').doc(friendId), {
        'friends': FieldValue.arrayRemove([userId])
      });

      await batch.commit();
      return true;
    } catch (e) {
      throw Exception('Failed to remove friend: ${e.toString()}');
    }
  }

  Future<List<UserModel>> getFriends(List<String> friendIds) async {
    try {
      if (friendIds.isEmpty) return [];

      final snapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: friendIds)
          .get();

      return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get friends: ${e.toString()}');
    }
  }

  Future<bool> updateProfile({
    required String userId,
    String? username,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (username != null) updates['username'] = username;
      if (bio != null) updates['bio'] = bio;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(userId).update(updates);
      }
      return true;
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }
}
