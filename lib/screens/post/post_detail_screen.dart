import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';
import '../../models/post_model.dart';
import '../../models/comment_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();
  List<CommentModel> _comments = [];
  bool _isLoadingComments = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final comments = await postProvider.getComments(widget.post.postId);
    setState(() {
      _comments = comments;
      _isLoadingComments = false;
    });
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;

    if (currentUser == null) return;

    final comment = CommentModel(
      commentId: const Uuid().v4(),
      postId: widget.post.postId,
      userId: currentUser.uid,
      username: currentUser.username,
      userProfileImage: currentUser.profileImageUrl,
      text: _commentController.text.trim(),
    );

    final success = await postProvider.addComment(comment);
    if (success) {
      _commentController.clear();
      await _loadComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserId = authProvider.currentUser?.uid ?? '';
    final isLiked = widget.post.isLikedBy(currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.username),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image carousel
                  if (widget.post.imageUrls.isNotEmpty)
                    SizedBox(
                      height: 400,
                      child: PageView.builder(
                        itemCount: widget.post.imageUrls.length,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: widget.post.imageUrls[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                    ),

                  // Actions
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                  postProvider.unlikePost(
                                      widget.post.postId, currentUserId);
                                } else {
                                  postProvider.likePost(
                                      widget.post.postId, currentUserId);
                                }
                              },
                            );
                          },
                        ),
                        Text('${widget.post.likes.length}'),
                        const SizedBox(width: 16),
                        const Icon(Icons.comment_outlined),
                        const SizedBox(width: 8),
                        Text('${_comments.length}'),
                      ],
                    ),
                  ),

                  // Location
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(widget.post.location.displayName),
                    subtitle: widget.post.location.address != null
                        ? Text(widget.post.location.address!)
                        : null,
                  ),

                  // Caption
                  if (widget.post.caption.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: '${widget.post.username} ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: widget.post.caption),
                          ],
                        ),
                      ),
                    ),

                  const Divider(),

                  // Comments section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Comments',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  if (_isLoadingComments)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_comments.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No comments yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: comment.userProfileImage != null
                                ? CachedNetworkImageProvider(
                                    comment.userProfileImage!)
                                : null,
                            child: comment.userProfileImage == null
                                ? Text(comment.username[0].toUpperCase())
                                : null,
                          ),
                          title: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: '${comment.username} ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: comment.text),
                              ],
                            ),
                          ),
                          subtitle: Text(
                            timeago.format(comment.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Comment input
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
