/// Entidad inmutable que representa un comentario en una publicación del foro (Principio V).
class CommunityComment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String content;
  final DateTime createdAt;

  const CommunityComment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.content,
    required this.createdAt,
  });

  /// Tiempo transcurrido legible en español (ej. "Justo ahora", "Hace 5m", "Hace 2h")
  String get formattedTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'Justo ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return 'Hace ${difference.inDays}d';
    }
  }

  CommunityComment copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? authorName,
    String? authorAvatarUrl,
    String? content,
    DateTime? createdAt,
  }) {
    return CommunityComment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommunityComment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          postId == other.postId &&
          authorId == other.authorId &&
          authorName == other.authorName &&
          authorAvatarUrl == other.authorAvatarUrl &&
          content == other.content &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      postId.hashCode ^
      authorId.hashCode ^
      authorName.hashCode ^
      authorAvatarUrl.hashCode ^
      content.hashCode ^
      createdAt.hashCode;
}
