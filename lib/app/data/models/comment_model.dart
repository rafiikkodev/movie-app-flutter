/// Model untuk komentar film
/// Mendukung nested replies (parent_id untuk threading)
class CommentModel {
  final String id;
  final int movieId;
  final String userId;
  final String? parentId; // null = top-level comment, not null = reply
  final String content;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  // User info (from join with profiles)
  final String? username;
  final String? fullName;
  final String? avatarUrl;

  // Current user state
  final bool isLikedByMe;

  // Replies (for threading)
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.movieId,
    required this.userId,
    this.parentId,
    required this.content,
    this.likesCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.username,
    this.fullName,
    this.avatarUrl,
    this.isLikedByMe = false,
    this.replies = const [],
  });

  /// Create from Supabase JSON response
  factory CommentModel.fromJson(
    Map<String, dynamic> json, {
    bool isLikedByMe = false,
  }) {
    // Handle profiles join
    final profiles = json['profiles'];

    return CommentModel(
      id: json['id'],
      movieId: json['movie_id'],
      userId: json['user_id'],
      parentId: json['parent_id'],
      content: json['content'],
      likesCount: json['likes_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      username: profiles?['username'],
      fullName: profiles?['full_name'],
      avatarUrl: profiles?['avatar_url'],
      isLikedByMe: isLikedByMe,
      replies: [],
    );
  }

  /// Convert to JSON for insert/update
  Map<String, dynamic> toJson() {
    return {
      'movie_id': movieId,
      'user_id': userId,
      'parent_id': parentId,
      'content': content,
    };
  }

  /// Display name - fallback ke username jika fullName kosong
  String get displayName =>
      fullName?.isNotEmpty == true ? fullName! : username ?? 'Anonymous';

  /// Avatar URL dengan default
  String get displayAvatarUrl =>
      avatarUrl ??
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=12cdd9&color=fff';

  /// Time ago format
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if this is a reply
  bool get isReply => parentId != null;

  /// Copy with method untuk optimistic updates
  CommentModel copyWith({
    String? id,
    int? movieId,
    String? userId,
    String? parentId,
    String? content,
    int? likesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? username,
    String? fullName,
    String? avatarUrl,
    bool? isLikedByMe,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      replies: replies ?? this.replies,
    );
  }
}

/// Model untuk user profile
class UserProfileModel {
  final String id;
  final String? username;
  final String? fullName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileModel({
    required this.id,
    this.username,
    this.fullName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }

  String get displayName =>
      fullName?.isNotEmpty == true ? fullName! : username ?? 'Anonymous';

  String get displayAvatarUrl =>
      avatarUrl ??
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=12cdd9&color=fff';
}
