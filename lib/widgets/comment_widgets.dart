import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';
import 'package:template_project_flutter/app/data/models/comment_model.dart';

/// Widget untuk single comment item
/// Mendukung replies (nested comments)
class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final bool isReply;
  final bool isMyComment;
  final bool isLikedByMe;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String commentId)? onViewReplies;

  const CommentCard({
    super.key,
    required this.comment,
    this.isReply = false,
    this.isMyComment = false,
    this.isLikedByMe = false,
    this.onLike,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.onViewReplies,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: isReply ? 48 : 0),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          _buildAvatar(),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Name + Time
                _buildHeader(context),
                const SizedBox(height: 6),
                // Comment content
                _buildContent(),
                const SizedBox(height: 10),
                // Actions: Like, Reply, etc
                _buildActions(context),
                // Replies preview
                if (!isReply && comment.replies.isNotEmpty)
                  _buildRepliesPreview(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: isReply ? 32 : 40,
      height: isReply ? 32 : 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: softColor),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: comment.displayAvatarUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: softColor,
            child: Icon(
              Icons.person,
              color: greyColor,
              size: isReply ? 16 : 20,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: softColor,
            child: Icon(
              Icons.person,
              color: greyColor,
              size: isReply ? 16 : 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                comment.displayName,
                style: whiteTextStyle.copyWith(
                  fontSize: isReply ? 13 : 14,
                  fontWeight: semiBold,
                ),
              ),
              if (isMyComment) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: darkBlueAccent.withAlpha(50),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'You',
                    style: darkBlueTextStyle.copyWith(
                      fontSize: 10,
                      fontWeight: medium,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Text(
                comment.timeAgo,
                style: greyTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                ),
              ),
            ],
          ),
        ),
        if (isMyComment)
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: greyColor, size: 18),
            color: softColor,
            onSelected: (value) {
              if (value == 'edit') onEdit?.call();
              if (value == 'delete') onDelete?.call();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: whiteColor, size: 18),
                    const SizedBox(width: 8),
                    Text('Edit', style: whiteTextStyle.copyWith(fontSize: 14)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: redColor, size: 18),
                    const SizedBox(width: 8),
                    Text('Delete', style: redTextStyle.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      comment.content,
      style: whiteTextStyle.copyWith(
        fontSize: isReply ? 13 : 14,
        fontWeight: regular,
        height: 1.4,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        // Like button
        _ActionButton(
          icon: isLikedByMe ? Icons.favorite : Icons.favorite_border,
          iconColor: isLikedByMe ? redColor : greyColor,
          label: comment.likesCount > 0 ? '${comment.likesCount}' : 'Like',
          onTap: onLike,
        ),
        const SizedBox(width: 20),
        // Reply button
        if (!isReply)
          _ActionButton(
            icon: Icons.reply,
            iconColor: greyColor,
            label: 'Reply',
            onTap: onReply,
          ),
      ],
    );
  }

  Widget _buildRepliesPreview() {
    return GestureDetector(
      onTap: () => onViewReplies?.call(comment.id),
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          children: [
            Container(width: 24, height: 1, color: greyColor.withAlpha(80)),
            const SizedBox(width: 8),
            Text(
              'View ${comment.replies.length} ${comment.replies.length == 1 ? 'reply' : 'replies'}',
              style: darkBlueTextStyle.copyWith(
                fontSize: 13,
                fontWeight: medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Action button untuk Like, Reply, dll
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: greyTextStyle.copyWith(fontSize: 12, fontWeight: medium),
          ),
        ],
      ),
    );
  }
}

/// Input field untuk menambah komentar
class CommentInputField extends StatefulWidget {
  final String? replyingToName;
  final VoidCallback? onCancelReply;
  final Function(String content) onSubmit;
  final bool isLoading;

  const CommentInputField({
    super.key,
    this.replyingToName,
    this.onCancelReply,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    widget.onSubmit(_controller.text.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softColor,
        border: Border(
          top: BorderSide(color: greyColor.withAlpha(30), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Replying to indicator
          if (widget.replyingToName != null)
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.reply, size: 16, color: darkBlueAccent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Replying to ${widget.replyingToName}',
                      style: darkBlueTextStyle.copyWith(
                        fontSize: 13,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onCancelReply,
                    child: Icon(Icons.close, size: 18, color: greyColor),
                  ),
                ],
              ),
            ),
          // Input row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: darkColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _controller,
                    style: whiteTextStyle.copyWith(fontSize: 14),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: widget.replyingToName != null
                          ? 'Write a reply...'
                          : 'Write a comment...',
                      hintStyle: greyTextStyle.copyWith(fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Send button
              GestureDetector(
                onTap: widget.isLoading || !_hasText ? null : _submit,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _hasText ? darkBlueAccent : greyColor.withAlpha(50),
                    shape: BoxShape.circle,
                  ),
                  child: widget.isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: whiteColor,
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          color: _hasText ? whiteColor : greyColor,
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Empty state widget untuk komentar
class CommentEmptyState extends StatelessWidget {
  const CommentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: greyColor.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            'No comments yet',
            style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share your thoughts!',
            style: greyTextStyle.copyWith(fontSize: 14, fontWeight: regular),
          ),
        ],
      ),
    );
  }
}

/// Loading state untuk komentar
class CommentLoadingState extends StatelessWidget {
  const CommentLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(child: CircularProgressIndicator(color: darkBlueAccent)),
    );
  }
}

/// Error state untuk komentar
class CommentErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CommentErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: redColor),
          const SizedBox(height: 16),
          Text(
            'Failed to load comments',
            style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: greyTextStyle.copyWith(fontSize: 14, fontWeight: regular),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: darkBlueTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Header section untuk komentar
class CommentSectionHeader extends StatelessWidget {
  final int commentCount;

  const CommentSectionHeader({super.key, required this.commentCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Comments',
          style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: darkBlueAccent.withAlpha(40),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$commentCount',
            style: darkBlueTextStyle.copyWith(
              fontSize: 12,
              fontWeight: semiBold,
            ),
          ),
        ),
      ],
    );
  }
}
