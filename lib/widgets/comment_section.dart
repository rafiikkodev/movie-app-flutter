import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/comment_model.dart';
import 'package:template_project_flutter/app/data/providers/comment_provider.dart';
import 'package:template_project_flutter/widgets/comment_widgets.dart';

/// Widget lengkap untuk menampilkan section komentar
/// Bisa digunakan di movie detail page atau page lain
class CommentSection extends StatefulWidget {
  final int movieId;
  final bool showHeader;
  final int? maxDisplayComments; // null = show all

  const CommentSection({
    super.key,
    required this.movieId,
    this.showHeader = true,
    this.maxDisplayComments,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  String? _replyingToCommentId;
  String? _replyingToName;
  Set<String> _expandedReplies = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Load comments saat widget pertama kali dibuild
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentProvider>().loadComments(widget.movieId);
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

    setState(() {
      _isSubmitting = true;
    });

    final success = await provider.addComment(
      movieId: widget.movieId,
      content: content,
      parentId: _replyingToCommentId,
    );

    setState(() {
      _isSubmitting = false;
      if (success) {
        _replyingToCommentId = null;
        _replyingToName = null;
        // Expand replies if it was a reply
        if (_replyingToCommentId != null) {
          _expandedReplies.add(_replyingToCommentId!);
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

    await provider.toggleLike(widget.movieId, commentId);
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
        widget.movieId,
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
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: greyTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newContent = controller.text.trim();
              if (newContent.isEmpty) return;

              Navigator.pop(context);

              final success = await context.read<CommentProvider>().editComment(
                widget.movieId,
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
    return Consumer<CommentProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isLoading(widget.movieId);
        final error = provider.getError(widget.movieId);
        final comments = provider.getComments(widget.movieId);
        final commentCount = provider.getCommentCount(widget.movieId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            if (widget.showHeader)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CommentSectionHeader(commentCount: commentCount),
              ),

            // Content
            if (isLoading && comments.isEmpty)
              const CommentLoadingState()
            else if (error != null && comments.isEmpty)
              CommentErrorState(
                message: error,
                onRetry: () => provider.loadComments(widget.movieId),
              )
            else if (comments.isEmpty)
              const CommentEmptyState()
            else
              _buildCommentsList(comments, provider),

            // Input field
            const SizedBox(height: 16),
            CommentInputField(
              replyingToName: _replyingToName,
              onCancelReply: _cancelReply,
              onSubmit: _submitComment,
              isLoading: _isSubmitting,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentsList(
    List<CommentModel> comments,
    CommentProvider provider,
  ) {
    final displayComments = widget.maxDisplayComments != null
        ? comments.take(widget.maxDisplayComments!).toList()
        : comments;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayComments.length,
      separatorBuilder: (context, index) =>
          Divider(color: greyColor.withAlpha(30), height: 1),
      itemBuilder: (context, index) {
        final comment = displayComments[index];
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

/// Compact version untuk preview di movie detail
class CommentPreviewSection extends StatelessWidget {
  final int movieId;
  final VoidCallback onViewAll;

  const CommentPreviewSection({
    super.key,
    required this.movieId,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, provider, child) {
        final comments = provider.getComments(movieId);
        final commentCount = provider.getCommentCount(movieId);
        final isLoading = provider.isLoading(movieId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan View All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommentSectionHeader(commentCount: commentCount),
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'View All',
                    style: darkBlueTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Preview (max 2 comments)
            if (isLoading && comments.isEmpty)
              const CommentLoadingState()
            else if (comments.isEmpty)
              const CommentEmptyState()
            else
              Column(
                children: comments.take(2).map((comment) {
                  return CommentCard(
                    comment: comment,
                    isMyComment: provider.isMyComment(comment.userId),
                    isLikedByMe: provider.isLikedByMe(comment.id),
                    onLike: () => provider.toggleLike(movieId, comment.id),
                  );
                }).toList(),
              ),

            // View All button
            if (comments.length > 2) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onViewAll,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: softColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'View all ${commentCount} comments',
                      style: darkBlueTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
