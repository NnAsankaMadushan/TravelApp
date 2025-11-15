import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> searchUsers(String query) async {
    try {
      _isLoading = true;
      notifyListeners();

      _users = await _userService.searchUsers(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendFriendRequest(String fromUserId, String toUserId) async {
    try {
      return await _userService.sendFriendRequest(fromUserId, toUserId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> acceptFriendRequest(String userId, String friendId) async {
    try {
      return await _userService.acceptFriendRequest(userId, friendId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFriend(String userId, String friendId) async {
    try {
      return await _userService.removeFriend(userId, friendId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<List<UserModel>> getFriends(List<String> friendIds) async {
    try {
      _isLoading = true;
      notifyListeners();

      final friends = await _userService.getFriends(friendIds);
      _isLoading = false;
      notifyListeners();
      return friends;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }
}
