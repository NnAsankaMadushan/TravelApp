import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/post_model.dart';
import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';
import '../screens/post/post_detail_screen.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserId = authProvider.currentUser?.uid ?? '';
    final isLiked = post.isLikedBy(currentUserId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.userProfileImage != null
                  ? CachedNetworkImageProvider(post.userProfileImage!)
                  : null,
              child: post.userProfileImage == null
                  ? Text(post.username[0].toUpperCase())
                  : null,
            ),
            title: Text(
              post.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.location_on, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    post.location.displayName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            trailing: Text(
              timeago.format(post.createdAt),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),

          // Image carousel
          if (post.imageUrls.isNotEmpty)
            SizedBox(
              height: 400,
              child: PageView.builder(
                itemCount: post.imageUrls.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: post.imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Consumer<PostProvider>(
                  builder: (context, postProvider, _) {
                    return IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : null,
                      ),
                      onPressed: () {
                        if (isLiked) {
                          postProvider.unlikePost(post.postId, currentUserId);
                        } else {
                          postProvider.likePost(post.postId, currentUserId);
                        }
                      },
                    );
                  },
                ),
                Text('${post.likes.length}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(post: post),
                      ),
                    );
                  },
                ),
                Text('${post.commentCount}'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.location_on_outlined),
                  onPressed: () {
                    // Navigate to map with this location
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Location: ${post.location.displayName}')),
                    );
                  },
                ),
              ],
            ),
          ),

          // Caption
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: '${post.username} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
