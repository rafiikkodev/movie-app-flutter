import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/movie_model.dart';
import 'package:template_project_flutter/app/data/models/comment_model.dart';
import 'package:template_project_flutter/app/data/providers/comment_provider.dart';
import 'package:template_project_flutter/widgets/app_bar.dart';
import 'package:template_project_flutter/widgets/comment_widgets.dart';

/// Halaman diskusi lengkap untuk sebuah film
/// Menampilkan semua komentar dengan fitur lengkap
class DiscussionPage extends StatefulWidget {
  final MovieModel movie;

  const DiscussionPage({super.key, required this.movie});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  String? _replyingToCommentId;
  String? _replyingToName;
  final Set<String> _expandedReplies = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentProvider>().loadComments(widget.movie.id);
    });
  }

  void _handleReply(CommentModel comment) {
    setState(() {
      _replyingToCommentId = comment.id;
      _replyingToName = comment.displayName;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingToCommentId = null;
      _replyingToName = null;
    });
  }

  void _toggleReplies(String commentId) {
    setState(() {
      if (_expandedReplies.contains(commentId)) {
        _expandedReplies.remove(commentId);
      } else {
        _expandedReplies.add(commentId);
      }
    });
  }

  Future<void> _submitComment(String content) async {
    final provider = context.read<CommentProvider>();

    if (!provider.isLoggedIn) {
      _showLoginRequired();
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
    });

    final parentId = _replyingToCommentId;
    final success = await provider.addComment(
      movieId: widget.movie.id,
      content: content,
      parentId: parentId,
    );

    setState(() {
      _isSubmitting = false;
      if (success) {
        _replyingToCommentId = null;
        _replyingToName = null;
        // Expand replies if it was a reply
        if (parentId != null) {
          _expandedReplies.add(parentId);
        }
      }
    });

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to post comment. Please try again.',
            style: whiteTextStyle.copyWith(fontSize: 14),
          ),
          backgroundColor: redColor,
        ),
      );
    }
  }

  Future<void> _handleLike(String commentId) async {
    final provider = context.read<CommentProvider>();

    if (!provider.isLoggedIn) {
      _showLoginRequired();
      return;
    }

    await provider.toggleLike(widget.movie.id, commentId);
  }

  Future<void> _handleDelete(CommentModel comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: softColor,
        title: Text(
          'Delete Comment',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        content: Text(
          'Are you sure you want to delete this comment?',
          style: greyTextStyle.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: greyTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: redTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await context.read<CommentProvider>().deleteComment(
        widget.movie.id,
        comment.id,
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete comment',
              style: whiteTextStyle.copyWith(fontSize: 14),
            ),
            backgroundColor: redColor,
          ),
        );
      }
    }
  }

  void _handleEdit(CommentModel comment) {
    final controller = TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: softColor,
        title: Text(
          'Edit Comment',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        content: Container(
          decoration: BoxDecoration(
            color: darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            style: whiteTextStyle.copyWith(fontSize: 14),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Edit your comment...',
              hintStyle: greyTextStyle.copyWith(fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: greyTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newContent = controller.text.trim();
              if (newContent.isEmpty) return;

              Navigator.pop(dialogContext);

              final success = await context.read<CommentProvider>().editComment(
                widget.movie.id,
                comment.id,
                newContent,
              );

              if (!success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Failed to edit comment',
                      style: whiteTextStyle.copyWith(fontSize: 14),
                    ),
                    backgroundColor: redColor,
                  ),
                );
              }
            },
            child: Text(
              'Save',
              style: darkBlueTextStyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginRequired() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Please login to comment',
          style: whiteTextStyle.copyWith(fontSize: 14),
        ),
        backgroundColor: darkBlueAccent,
        action: SnackBarAction(
          label: 'Login',
          textColor: whiteColor,
          onPressed: () {
            Navigator.pushNamed(context, '/sign-in');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: CustomScrollView(
              slivers: [
                // App Bar
                CustomAppBar(showBackButton: true, title: 'Discussion'),

                // Content dengan padding seperti wishlist page
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie info header
                        _buildMovieHeader(),
                        const SizedBox(height: 24),
                        // Comments header
                        Consumer<CommentProvider>(
                          builder: (context, provider, child) {
                            final commentCount = provider.getCommentCount(
                              widget.movie.id,
                            );
                            return CommentSectionHeader(
                              commentCount: commentCount,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Comments list
                        _buildCommentsContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fixed input at bottom
          Consumer<CommentProvider>(
            builder: (context, provider, child) {
              return CommentInputField(
                replyingToName: _replyingToName,
                onCancelReply: _cancelReply,
                onSubmit: _submitComment,
                isLoading: _isSubmitting,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMovieHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.movie.posterUrl,
              width: 50,
              height: 75,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 75,
                  color: darkGreyColor,
                  child: Icon(Icons.movie, color: greyColor),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title,
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.movie.year,
                  style: greyTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: regular,
                  ),
                ),
              ],
            ),
          ),
          // Comment count
          Consumer<CommentProvider>(
            builder: (context, provider, child) {
              final count = provider.getCommentCount(widget.movie.id);
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: darkBlueAccent.withAlpha(40),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 16,
                      color: darkBlueAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$count',
                      style: darkBlueTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsContent() {
    return Consumer<CommentProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isLoading(widget.movie.id);
        final error = provider.getError(widget.movie.id);
        final comments = provider.getComments(widget.movie.id);

        if (isLoading && comments.isEmpty) {
          return const CommentLoadingState();
        } else if (error != null && comments.isEmpty) {
          return CommentErrorState(
            message: error,
            onRetry: () => provider.loadComments(widget.movie.id),
          );
        } else if (comments.isEmpty) {
          return const CommentEmptyState();
        } else {
          return _buildCommentsList(comments, provider);
        }
      },
    );
  }

  Widget _buildCommentsList(
    List<CommentModel> comments,
    CommentProvider provider,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      separatorBuilder: (context, index) =>
          Divider(color: greyColor.withAlpha(30), height: 1),
      itemBuilder: (context, index) {
        final comment = comments[index];
        return _buildCommentItem(comment, provider);
      },
    );
  }

  Widget _buildCommentItem(CommentModel comment, CommentProvider provider) {
    final isExpanded = _expandedReplies.contains(comment.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main comment
        CommentCard(
          comment: comment,
          isReply: false,
          isMyComment: provider.isMyComment(comment.userId),
          isLikedByMe: provider.isLikedByMe(comment.id),
          onLike: () => _handleLike(comment.id),
          onReply: () => _handleReply(comment),
          onEdit: () => _handleEdit(comment),
          onDelete: () => _handleDelete(comment),
          onViewReplies: _toggleReplies,
        ),

        // Replies
        if (comment.replies.isNotEmpty && isExpanded)
          Container(
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: greyColor.withAlpha(50), width: 2),
              ),
            ),
            child: Column(
              children: comment.replies.map((reply) {
                return CommentCard(
                  comment: reply,
                  isReply: true,
                  isMyComment: provider.isMyComment(reply.userId),
                  isLikedByMe: provider.isLikedByMe(reply.id),
                  onLike: () => _handleLike(reply.id),
                  onEdit: () => _handleEdit(reply),
                  onDelete: () => _handleDelete(reply),
                );
              }).toList(),
            ),
          ),

        // Collapse button
        if (comment.replies.isNotEmpty && isExpanded)
          GestureDetector(
            onTap: () => _toggleReplies(comment.id),
            child: Padding(
              padding: const EdgeInsets.only(left: 52, top: 8, bottom: 8),
              child: Text(
                'Hide replies',
                style: greyTextStyle.copyWith(fontSize: 13, fontWeight: medium),
              ),
            ),
          ),
      ],
    );
  }
}
