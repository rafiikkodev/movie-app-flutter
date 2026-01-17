import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_project_flutter/app/data/models/comment_model.dart';
import 'package:template_project_flutter/app/core/utils/logger.dart';

/// CommentProvider dengan optimistic update dan pagination
class CommentProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const int _commentsLimit = 50;

  Map<int, List<CommentModel>> _commentsByMovie = {};
  Map<int, bool> _loadingByMovie = {};
  Map<int, String?> _errorByMovie = {};
  Set<String> _likedCommentIds = {};

  List<CommentModel> getComments(int movieId) =>
      _commentsByMovie[movieId] ?? [];
  bool isLoading(int movieId) => _loadingByMovie[movieId] ?? false;
  String? getError(int movieId) => _errorByMovie[movieId];

  String? get _userId => _supabase.auth.currentUser?.id;
  bool get isLoggedIn => _userId != null;

  Future<void> loadComments(int movieId) async {
    if (_loadingByMovie[movieId] == true) return;

    _loadingByMovie[movieId] = true;
    _errorByMovie[movieId] = null;
    notifyListeners();

    try {
      // Optimized: limit 50 comments + select specific fields
      final commentsResponse = await _supabase
          .from('comments')
          .select(
            'id, movie_id, user_id, parent_id, content, likes_count, created_at, updated_at',
          )
          .eq('movie_id', movieId)
          .order('created_at', ascending: false)
          .limit(_commentsLimit);

      final commentsList = commentsResponse as List;

      final userIds = commentsList
          .map((c) => c['user_id'] as String)
          .toSet()
          .toList();

      Map<String, Map<String, dynamic>> profilesMap = {};
      if (userIds.isNotEmpty) {
        final profilesResponse = await _supabase
            .from('profiles')
            .select('id, username, full_name, avatar_url')
            .inFilter('id', userIds);

        for (final profile in (profilesResponse as List)) {
          profilesMap[profile['id']] = profile;
        }
      }

      if (_userId != null) {
        final likedResponse = await _supabase
            .from('comment_likes')
            .select('comment_id')
            .eq('user_id', _userId!)
            .limit(200);

        _likedCommentIds = (likedResponse as List)
            .map((e) => e['comment_id'] as String)
            .toSet();
      }

      // Parse comments dengan profile data
      final allComments = commentsList.map((json) {
        final userId = json['user_id'] as String;
        final profile = profilesMap[userId];
        final isLiked = _likedCommentIds.contains(json['id']);

        // Merge profile data ke json
        final Map<String, dynamic> mergedJson = Map<String, dynamic>.from(json);
        mergedJson['profiles'] = profile;

        return CommentModel.fromJson(mergedJson, isLikedByMe: isLiked);
      }).toList();

      // Organize into threads (top-level + replies)
      final topLevelComments = <CommentModel>[];
      final repliesMap = <String, List<CommentModel>>{};

      for (final comment in allComments) {
        if (comment.parentId == null) {
          topLevelComments.add(comment);
        } else {
          repliesMap.putIfAbsent(comment.parentId!, () => []);
          repliesMap[comment.parentId!]!.add(comment);
        }
      }

      // Attach replies to parent comments
      _commentsByMovie[movieId] = topLevelComments.map((comment) {
        final replies = repliesMap[comment.id] ?? [];
        // Sort replies by oldest first
        replies.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return comment.copyWith(replies: replies);
      }).toList();

      _loadingByMovie[movieId] = false;
      notifyListeners();
    } catch (e) {
      _errorByMovie[movieId] = e.toString();
      _loadingByMovie[movieId] = false;
      notifyListeners();
      LoggerService.error('Error loading comments', e);
    }
  }

  /// Add new comment dengan OPTIMISTIC UPDATE
  Future<bool> addComment({
    required int movieId,
    required String content,
    String? parentId,
  }) async {
    if (_userId == null) return false;

    // Get current user profile
    final userProfile = await _getCurrentUserProfile();

    // Create optimistic comment
    final optimisticComment = CommentModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      movieId: movieId,
      userId: _userId!,
      parentId: parentId,
      content: content,
      likesCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      username: userProfile?.username,
      fullName: userProfile?.fullName,
      avatarUrl: userProfile?.avatarUrl,
      isLikedByMe: false,
    );

    // === OPTIMISTIC UPDATE ===
    _addCommentOptimistically(movieId, optimisticComment);
    notifyListeners();

    try {
      // Insert to server - tanpa join, gunakan data profile dari optimistic comment
      final response = await _supabase
          .from('comments')
          .insert({
            'movie_id': movieId,
            'user_id': _userId,
            'parent_id': parentId,
            'content': content,
          })
          .select('*')
          .single();

      // Replace optimistic comment with real one (keep profile data from optimistic)
      final realComment = CommentModel(
        id: response['id'],
        movieId: response['movie_id'],
        userId: response['user_id'],
        parentId: response['parent_id'],
        content: response['content'],
        likesCount: response['likes_count'] ?? 0,
        createdAt: DateTime.parse(response['created_at']),
        updatedAt: DateTime.parse(response['updated_at']),
        username: optimisticComment.username,
        fullName: optimisticComment.fullName,
        avatarUrl: optimisticComment.avatarUrl,
        isLikedByMe: false,
      );
      _replaceOptimisticComment(movieId, optimisticComment.id, realComment);
      notifyListeners();

      return true;
    } catch (e) {
      // ROLLBACK: Remove optimistic comment
      _removeComment(movieId, optimisticComment.id);
      notifyListeners();
      LoggerService.error('Error adding comment', e);
      return false;
    }
  }

  /// Like/Unlike comment dengan OPTIMISTIC UPDATE
  Future<bool> toggleLike(int movieId, String commentId) async {
    if (_userId == null) return false;

    final isCurrentlyLiked = _likedCommentIds.contains(commentId);

    // === OPTIMISTIC UPDATE ===
    if (isCurrentlyLiked) {
      _likedCommentIds.remove(commentId);
      _updateCommentLikeCount(movieId, commentId, -1);
    } else {
      _likedCommentIds.add(commentId);
      _updateCommentLikeCount(movieId, commentId, 1);
    }
    notifyListeners();

    try {
      if (isCurrentlyLiked) {
        // Unlike
        await _supabase
            .from('comment_likes')
            .delete()
            .eq('comment_id', commentId)
            .eq('user_id', _userId!);
      } else {
        // Like
        await _supabase.from('comment_likes').insert({
          'comment_id': commentId,
          'user_id': _userId,
        });
      }
      return true;
    } catch (e) {
      // ROLLBACK
      if (isCurrentlyLiked) {
        _likedCommentIds.add(commentId);
        _updateCommentLikeCount(movieId, commentId, 1);
      } else {
        _likedCommentIds.remove(commentId);
        _updateCommentLikeCount(movieId, commentId, -1);
      }
      notifyListeners();
      LoggerService.error('Error toggling like', e);
      return false;
    }
  }

  /// Delete comment
  Future<bool> deleteComment(int movieId, String commentId) async {
    if (_userId == null) return false;

    // Find and backup comment for rollback
    final backup = _findComment(movieId, commentId);
    if (backup == null) return false;

    // === OPTIMISTIC UPDATE ===
    _removeComment(movieId, commentId);
    notifyListeners();

    try {
      await _supabase
          .from('comments')
          .delete()
          .eq('id', commentId)
          .eq('user_id', _userId!);

      return true;
    } catch (e) {
      // ROLLBACK
      _addCommentOptimistically(movieId, backup);
      notifyListeners();
      LoggerService.error('Error deleting comment', e);
      return false;
    }
  }

  /// Edit comment
  Future<bool> editComment(
    int movieId,
    String commentId,
    String newContent,
  ) async {
    if (_userId == null) return false;

    final oldComment = _findComment(movieId, commentId);
    if (oldComment == null) return false;

    // === OPTIMISTIC UPDATE ===
    _updateCommentContent(movieId, commentId, newContent);
    notifyListeners();

    try {
      await _supabase
          .from('comments')
          .update({'content': newContent})
          .eq('id', commentId)
          .eq('user_id', _userId!);

      return true;
    } catch (e) {
      // ROLLBACK
      _updateCommentContent(movieId, commentId, oldComment.content);
      notifyListeners();
      LoggerService.error('Error editing comment', e);
      return false;
    }
  }

  /// Check if current user liked a comment
  bool isLikedByMe(String commentId) => _likedCommentIds.contains(commentId);

  /// Check if comment belongs to current user
  bool isMyComment(String commentUserId) => _userId == commentUserId;

  /// Get total comment count for a movie
  int getCommentCount(int movieId) {
    final comments = _commentsByMovie[movieId] ?? [];
    int count = comments.length;
    for (final comment in comments) {
      count += comment.replies.length;
    }
    return count;
  }

  // ========== HELPER METHODS ==========

  void _addCommentOptimistically(int movieId, CommentModel comment) {
    _commentsByMovie.putIfAbsent(movieId, () => []);

    if (comment.parentId == null) {
      // Top-level comment - add at beginning
      _commentsByMovie[movieId]!.insert(0, comment);
    } else {
      // Reply - add to parent's replies
      final comments = _commentsByMovie[movieId]!;
      for (int i = 0; i < comments.length; i++) {
        if (comments[i].id == comment.parentId) {
          final updatedReplies = [...comments[i].replies, comment];
          _commentsByMovie[movieId]![i] = comments[i].copyWith(
            replies: updatedReplies,
          );
          break;
        }
      }
    }
  }

  void _replaceOptimisticComment(
    int movieId,
    String tempId,
    CommentModel realComment,
  ) {
    final comments = _commentsByMovie[movieId];
    if (comments == null) return;

    if (realComment.parentId == null) {
      // Top-level
      for (int i = 0; i < comments.length; i++) {
        if (comments[i].id == tempId) {
          _commentsByMovie[movieId]![i] = realComment;
          return;
        }
      }
    } else {
      // Reply
      for (int i = 0; i < comments.length; i++) {
        if (comments[i].id == realComment.parentId) {
          final replies = comments[i].replies;
          for (int j = 0; j < replies.length; j++) {
            if (replies[j].id == tempId) {
              final updatedReplies = [...replies];
              updatedReplies[j] = realComment;
              _commentsByMovie[movieId]![i] = comments[i].copyWith(
                replies: updatedReplies,
              );
              return;
            }
          }
        }
      }
    }
  }

  void _removeComment(int movieId, String commentId) {
    final comments = _commentsByMovie[movieId];
    if (comments == null) return;

    // Try to remove from top-level
    _commentsByMovie[movieId]!.removeWhere((c) => c.id == commentId);

    // Try to remove from replies
    for (int i = 0; i < _commentsByMovie[movieId]!.length; i++) {
      final comment = _commentsByMovie[movieId]![i];
      if (comment.replies.any((r) => r.id == commentId)) {
        final updatedReplies = comment.replies
            .where((r) => r.id != commentId)
            .toList();
        _commentsByMovie[movieId]![i] = comment.copyWith(
          replies: updatedReplies,
        );
      }
    }
  }

  void _updateCommentLikeCount(int movieId, String commentId, int delta) {
    final comments = _commentsByMovie[movieId];
    if (comments == null) return;

    for (int i = 0; i < comments.length; i++) {
      if (comments[i].id == commentId) {
        _commentsByMovie[movieId]![i] = comments[i].copyWith(
          likesCount: comments[i].likesCount + delta,
          isLikedByMe: delta > 0,
        );
        return;
      }

      // Check replies
      for (int j = 0; j < comments[i].replies.length; j++) {
        if (comments[i].replies[j].id == commentId) {
          final updatedReplies = [...comments[i].replies];
          updatedReplies[j] = updatedReplies[j].copyWith(
            likesCount: updatedReplies[j].likesCount + delta,
            isLikedByMe: delta > 0,
          );
          _commentsByMovie[movieId]![i] = comments[i].copyWith(
            replies: updatedReplies,
          );
          return;
        }
      }
    }
  }

  void _updateCommentContent(int movieId, String commentId, String content) {
    final comments = _commentsByMovie[movieId];
    if (comments == null) return;

    for (int i = 0; i < comments.length; i++) {
      if (comments[i].id == commentId) {
        _commentsByMovie[movieId]![i] = comments[i].copyWith(content: content);
        return;
      }

      // Check replies
      for (int j = 0; j < comments[i].replies.length; j++) {
        if (comments[i].replies[j].id == commentId) {
          final updatedReplies = [...comments[i].replies];
          updatedReplies[j] = updatedReplies[j].copyWith(content: content);
          _commentsByMovie[movieId]![i] = comments[i].copyWith(
            replies: updatedReplies,
          );
          return;
        }
      }
    }
  }

  CommentModel? _findComment(int movieId, String commentId) {
    final comments = _commentsByMovie[movieId];
    if (comments == null) return null;

    for (final comment in comments) {
      if (comment.id == commentId) return comment;
      for (final reply in comment.replies) {
        if (reply.id == commentId) return reply;
      }
    }
    return null;
  }

  Future<UserProfileModel?> _getCurrentUserProfile() async {
    if (_userId == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', _userId!)
          .maybeSingle();

      if (response != null) {
        return UserProfileModel.fromJson(response);
      }
    } catch (e) {
      debugPrint('Error getting user profile: $e');
    }
    return null;
  }

  /// Clear cache untuk movie tertentu
  void clearCache(int movieId) {
    _commentsByMovie.remove(movieId);
    _loadingByMovie.remove(movieId);
    _errorByMovie.remove(movieId);
    notifyListeners();
  }

  /// Reset semua state
  void reset() {
    _commentsByMovie = {};
    _loadingByMovie = {};
    _errorByMovie = {};
    _likedCommentIds = {};
    notifyListeners();
  }
}
