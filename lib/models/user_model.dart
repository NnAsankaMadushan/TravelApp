class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? profileImageUrl;
  final String? bio;
  final List<String> friends;
  final List<String> friendRequests;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.profileImageUrl,
    this.bio,
    List<String>? friends,
    List<String>? friendRequests,
    DateTime? createdAt,
  })  : friends = friends ?? [],
        friendRequests = friendRequests ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'friends': friends,
      'friendRequests': friendRequests,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      bio: json['bio'],
      friends: List<String>.from(json['friends'] ?? []),
      friendRequests: List<String>.from(json['friendRequests'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? profileImageUrl,
    String? bio,
    List<String>? friends,
    List<String>? friendRequests,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      friends: friends ?? this.friends,
      friendRequests: friendRequests ?? this.friendRequests,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
