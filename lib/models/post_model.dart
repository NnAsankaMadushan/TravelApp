import 'location_model.dart';

class PostModel {
  final String postId;
  final String userId;
  final String username;
  final String? userProfileImage;
  final List<String> imageUrls;
  final String caption;
  final LocationModel location;
  final List<String> likes;
  final int commentCount;
  final DateTime createdAt;

  PostModel({
    required this.postId,
    required this.userId,
    required this.username,
    this.userProfileImage,
    required this.imageUrls,
    required this.caption,
    required this.location,
    List<String>? likes,
    this.commentCount = 0,
    DateTime? createdAt,
  })  : likes = likes ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'userProfileImage': userProfileImage,
      'imageUrls': imageUrls,
      'caption': caption,
      'location': location.toJson(),
      'likes': likes,
      'commentCount': commentCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      userProfileImage: json['userProfileImage'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      caption: json['caption'] ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
      likes: List<String>.from(json['likes'] ?? []),
      commentCount: json['commentCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  PostModel copyWith({
    String? postId,
    String? userId,
    String? username,
    String? userProfileImage,
    List<String>? imageUrls,
    String? caption,
    LocationModel? location,
    List<String>? likes,
    int? commentCount,
    DateTime? createdAt,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      imageUrls: imageUrls ?? this.imageUrls,
      caption: caption ?? this.caption,
      location: location ?? this.location,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool isLikedBy(String userId) {
    return likes.contains(userId);
  }
}
