import 'community_avatar.dart';
import 'community_comment.dart';
import 'community_mood_category.dart';
import 'embedded_card_data.dart';

/// Entidad inmutable que representa una publicación en el foro comunitario (Principio V).
class CommunityPost {
  final String id;
  final String authorAlias;
  final String authorRole;
  final CommunityAvatar avatar;
  final String faculty;
  final String timeAgo;
  final List<String> tags;
  final String content;
  final CommunityMoodCategory moodCategory;
  final EmbeddedCardData embeddedCard;
  final int supportCount;
  final int calmCount;
  final int insightCount;
  final int hugCount;
  final int commentCount;
  final Set<String> userReactions;
  final List<CommunityComment> comments;
  final Map<String, Set<String>> emojiReactions;
  final DateTime createdAt;

  const CommunityPost({
    required this.id,
    required this.authorAlias,
    required this.authorRole,
    required this.avatar,
    required this.faculty,
    required this.timeAgo,
    required this.tags,
    required this.content,
    required this.moodCategory,
    this.embeddedCard =
        const EmbeddedCardData(type: EmbeddedCardType.none, title: ''),
    this.supportCount = 0,
    this.calmCount = 0,
    this.insightCount = 0,
    this.hugCount = 0,
    this.commentCount = 0,
    this.userReactions = const {},
    this.comments = const [],
    this.emojiReactions = const {},
    required this.createdAt,
  });

  /// Indica si el usuario actual reaccionó con la clave estándar ('support', 'calm', 'insight', 'hug')
  bool hasReaction(String key) => userReactions.contains(key);

  /// Indica si un usuario específico reaccionó con un emoji particular
  bool hasUserEmojiReaction(String emoji, String userId) {
    return emojiReactions[emoji]?.contains(userId) ?? false;
  }

  /// Retorna la cantidad de reacciones para un emoji específico
  int getEmojiCount(String emoji) {
    return emojiReactions[emoji]?.length ?? 0;
  }

  /// Conteo consolidado de comentarios
  int get totalComments => comments.isNotEmpty ? comments.length : commentCount;

  CommunityPost copyWith({
    String? id,
    String? authorAlias,
    String? authorRole,
    CommunityAvatar? avatar,
    String? faculty,
    String? timeAgo,
    List<String>? tags,
    String? content,
    CommunityMoodCategory? moodCategory,
    EmbeddedCardData? embeddedCard,
    int? supportCount,
    int? calmCount,
    int? insightCount,
    int? hugCount,
    int? commentCount,
    Set<String>? userReactions,
    List<CommunityComment>? comments,
    Map<String, Set<String>>? emojiReactions,
    DateTime? createdAt,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      authorAlias: authorAlias ?? this.authorAlias,
      authorRole: authorRole ?? this.authorRole,
      avatar: avatar ?? this.avatar,
      faculty: faculty ?? this.faculty,
      timeAgo: timeAgo ?? this.timeAgo,
      tags: tags ?? this.tags,
      content: content ?? this.content,
      moodCategory: moodCategory ?? this.moodCategory,
      embeddedCard: embeddedCard ?? this.embeddedCard,
      supportCount: supportCount ?? this.supportCount,
      calmCount: calmCount ?? this.calmCount,
      insightCount: insightCount ?? this.insightCount,
      hugCount: hugCount ?? this.hugCount,
      commentCount: commentCount ?? this.commentCount,
      userReactions: userReactions ?? this.userReactions,
      comments: comments ?? this.comments,
      emojiReactions: emojiReactions ?? this.emojiReactions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommunityPost &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          authorAlias == other.authorAlias &&
          authorRole == other.authorRole &&
          avatar == other.avatar &&
          faculty == other.faculty &&
          timeAgo == other.timeAgo &&
          content == other.content &&
          moodCategory == other.moodCategory &&
          embeddedCard == other.embeddedCard &&
          supportCount == other.supportCount &&
          calmCount == other.calmCount &&
          insightCount == other.insightCount &&
          hugCount == other.hugCount &&
          commentCount == other.commentCount &&
          comments.length == other.comments.length &&
          emojiReactions.length == other.emojiReactions.length &&
          userReactions.length == other.userReactions.length &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      authorAlias.hashCode ^
      authorRole.hashCode ^
      avatar.hashCode ^
      faculty.hashCode ^
      timeAgo.hashCode ^
      content.hashCode ^
      moodCategory.hashCode ^
      embeddedCard.hashCode ^
      supportCount.hashCode ^
      calmCount.hashCode ^
      insightCount.hashCode ^
      hugCount.hashCode ^
      commentCount.hashCode ^
      comments.length.hashCode ^
      emojiReactions.length.hashCode ^
      createdAt.hashCode;
}
