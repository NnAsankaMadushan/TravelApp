import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/post_grid_item.dart';

class UserProfileScreen extends StatefulWidget {
  final UserModel user;

  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserPosts();
  }

  Future<void> _loadUserPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.loadUserPosts(widget.user.uid);
  }

  Future<void> _sendFriendRequest() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUserId = authProvider.currentUser?.uid;

    if (currentUserId != null) {
      final success = await userProvider.sendFriendRequest(
        currentUserId,
        widget.user.uid,
      );

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend request sent')),
        );
      }
    }
  }

  Future<void> _removeFriend() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUserId = authProvider.currentUser?.uid;

    if (currentUserId != null) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remove Friend'),
          content: Text(
              'Are you sure you want to remove ${widget.user.username} from your friends?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final success = await userProvider.removeFriend(
          currentUserId,
          widget.user.uid,
        );

        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Removed ${widget.user.username} from friends')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final currentUser = authProvider.currentUser;
          final isFriend = currentUser?.friends.contains(widget.user.uid) ?? false;
          final hasPendingRequest =
              widget.user.friendRequests.contains(currentUser?.uid);

          return RefreshIndicator(
            onRefresh: _loadUserPosts,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: widget.user.profileImageUrl != null
                              ? NetworkImage(widget.user.profileImageUrl!)
                              : null,
                          child: widget.user.profileImageUrl == null
                              ? Text(
                                  widget.user.username[0].toUpperCase(),
                                  style: const TextStyle(fontSize: 32),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.user.username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.user.bio != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.user.bio!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),

                        // Friend button
                        if (currentUser?.uid != widget.user.uid)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isFriend
                                  ? _removeFriend
                                  : hasPendingRequest
                                      ? null
                                      : _sendFriendRequest,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFriend ? Colors.grey : null,
                              ),
                              child: Text(
                                isFriend
                                    ? 'Friends'
                                    : hasPendingRequest
                                        ? 'Request Pending'
                                        : 'Add Friend',
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),
                        Consumer<PostProvider>(
                          builder: (context, postProvider, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatColumn(
                                  'Posts',
                                  postProvider.posts.length.toString(),
                                ),
                                _buildStatColumn(
                                  'Friends',
                                  widget.user.friends.length.toString(),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(Icons.grid_on),
                            SizedBox(width: 8),
                            Text(
                              'Posts',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<PostProvider>(
                  builder: (context, postProvider, _) {
                    if (postProvider.isLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (postProvider.posts.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text('No posts yet')),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.all(2.0),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return PostGridItem(post: postProvider.posts[index]);
                          },
                          childCount: postProvider.posts.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
