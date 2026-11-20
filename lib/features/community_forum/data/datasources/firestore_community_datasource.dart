import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/community_avatar.dart';
import '../../domain/entities/community_comment.dart';
import '../../domain/entities/community_mood_category.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/embedded_card_data.dart';

/// Fuente de datos de Cloud Firestore para el Foro Comunitario.
/// Almacena publicaciones y comentarios de apoyo estudiantil en:
/// - `community_posts/{postId}`
/// - `community_posts/{postId}/comments/{commentId}`
class FirestoreCommunityDataSource {
  final FirebaseService _firebaseService;

  FirestoreCommunityDataSource({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  CollectionReference<Map<String, dynamic>> get _postsCollection =>
      _firebaseService.communityPostsCollection;

  CollectionReference<Map<String, dynamic>> _commentsCollection(String postId) =>
      _firebaseService.communityCommentsCollection(postId);

  /// Obtiene las publicaciones ordenadas por fecha de creación (más recientes primero)
  Future<List<CommunityPost>> getPosts({String? currentUserId}) async {
    try {
      final snapshot = await _postsCollection
          .orderBy('createdAtMillis', descending: true)
          .limit(50)
          .get();

      final resolvedUser = (currentUserId != null && currentUserId.isNotEmpty)
          ? currentUserId
          : _firebaseService.currentUserId;

      // Carga concurrente paralela (Future.wait) optimizada: sólo consulta comentarios si commentCount > 0
      final posts = await Future.wait(snapshot.docs.map((doc) async {
        List<CommunityComment> comments = [];
        final data = doc.data();
        final count = (data['commentCount'] as int?) ?? 0;
        if (count > 0) {
          try {
            final commentsSnapshot = await _commentsCollection(doc.id)
                .orderBy('createdAtMillis', descending: false)
                .get();

            comments = commentsSnapshot.docs
                .map((cDoc) => _commentFromFirestore(cDoc.data(), cDoc.id))
                .toList();
          } catch (_) {}
        }

        return _postFromFirestore(
          data,
          doc.id,
          comments,
          currentUserId: resolvedUser,
        );
      }));
      return posts;
    } catch (e) {
      debugPrint('[FirestoreCommunityDataSource] Error en getPosts: $e');
      rethrow;
    }
  }

  /// Stream en tiempo real de publicaciones del foro
  Stream<List<CommunityPost>> watchPosts() {
    return _postsCollection
        .orderBy('createdAtMillis', descending: true)
        .limit(50)
        .snapshots()
        .asyncMap((snapshot) async {
      final resolvedUser = _firebaseService.currentUserId;
      // Paralelización concurrente de subcolecciones sólo cuando existen comentarios
      final posts = await Future.wait(snapshot.docs.map((doc) async {
        List<CommunityComment> comments = [];
        final data = doc.data();
        final count = (data['commentCount'] as int?) ?? 0;
        if (count > 0) {
          try {
            final commentsSnapshot = await _commentsCollection(doc.id)
                .orderBy('createdAtMillis', descending: false)
                .get();

            comments = commentsSnapshot.docs
                .map((cDoc) => _commentFromFirestore(cDoc.data(), cDoc.id))
                .toList();
          } catch (_) {}
        }

        return _postFromFirestore(
          data,
          doc.id,
          comments,
          currentUserId: resolvedUser,
        );
      }));
      return posts;
    });
  }

  /// Guarda una nueva publicación en Cloud Firestore con lote atómico WriteBatch
  Future<void> savePost(CommunityPost post) async {
    try {
      final data = _postToFirestore(post);
      data['updatedAt'] = FieldValue.serverTimestamp();

      final batch = _firebaseService.firestore.batch();
      batch.set(_postsCollection.doc(post.id), data, SetOptions(merge: true));

      // Si tiene comentarios adjuntos iniciales, los persiste en subcolección en el mismo lote
      for (final comment in post.comments) {
        batch.set(
          _commentsCollection(post.id).doc(comment.id),
          _commentToFirestore(comment),
          SetOptions(merge: true),
        );
      }

      await batch.commit();
      debugPrint('[FirestoreCommunityDataSource] Post guardado atómicamente en Firestore: ${post.id}');
    } catch (e) {
      debugPrint('[FirestoreCommunityDataSource] Error en savePost: $e');
      rethrow;
    }
  }

  /// Agrega un comentario anónimo a una publicación y actualiza el contador
  Future<void> addComment({
    required String postId,
    required CommunityComment comment,
  }) async {
    final postRef = _postsCollection.doc(postId);
    final commentRef = _commentsCollection(postId).doc(comment.id);

    await _firebaseService.firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);
      if (!postDoc.exists) return;

      final currentCommentsCount =
          (postDoc.data()?['commentCount'] as int?) ?? 0;

      transaction.set(commentRef, _commentToFirestore(comment));
      transaction.update(postRef, {
        'commentCount': currentCommentsCount + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Conmuta reacciones estándar ('support', 'calm', 'insight', 'hug')
  Future<void> toggleReaction(String postId, String reactionKey, {String? userId}) async {
    final emojiMap = {
      'support': '❤️',
      'calm': '🌿',
      'insight': '💡',
      'hug': '🫂',
    };
    final emoji = emojiMap[reactionKey] ?? reactionKey;
    final activeUserId = (userId != null && userId.isNotEmpty)
        ? userId
        : (_firebaseService.currentUserId.isNotEmpty
            ? _firebaseService.currentUserId
            : 'current_user_local');

    await toggleEmojiReaction(
      postId: postId,
      emoji: emoji,
      userId: activeUserId,
    );
  }

  /// Conmuta atómicamente una reacción con emoji para un usuario:
  /// Primer toque: envía la reacción y suma 1.
  /// Segundo toque sobre el mismo emoji: quita la reacción y resta 1.
  Future<void> toggleEmojiReaction({
    required String postId,
    required String emoji,
    required String userId,
  }) async {
    final postRef = _postsCollection.doc(postId);

    await _firebaseService.firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      if (!snapshot.exists) return;

      final data = snapshot.data() ?? {};
      final rawEmojiMap = (data['emojiReactions'] as Map<String, dynamic>?) ?? {};
      final rawUsers = rawEmojiMap[emoji];
      final userList = rawUsers is List
          ? rawUsers.map((e) => e.toString()).toList()
          : <String>[];

      final wasPresent = userList.contains(userId);
      if (wasPresent) {
        userList.remove(userId);
      } else {
        userList.add(userId);
      }

      final updatedMap = Map<String, dynamic>.from(rawEmojiMap);
      if (userList.isEmpty) {
        updatedMap.remove(emoji);
      } else {
        updatedMap[emoji] = userList;
      }

      int supportCount = (data['supportCount'] as int?) ?? 0;
      int calmCount = (data['calmCount'] as int?) ?? 0;
      int insightCount = (data['insightCount'] as int?) ?? 0;
      int hugCount = (data['hugCount'] as int?) ?? 0;

      if (emoji == '❤️' || emoji == '🤍') {
        supportCount = wasPresent
            ? (supportCount - 1).clamp(0, 99999)
            : supportCount + 1;
      } else if (emoji == '🌿') {
        calmCount = wasPresent
            ? (calmCount - 1).clamp(0, 99999)
            : calmCount + 1;
      } else if (emoji == '💡') {
        insightCount = wasPresent
            ? (insightCount - 1).clamp(0, 99999)
            : insightCount + 1;
      } else if (emoji == '🫂') {
        hugCount = wasPresent
            ? (hugCount - 1).clamp(0, 99999)
            : hugCount + 1;
      }

      transaction.update(postRef, {
        'emojiReactions': updatedMap,
        'supportCount': supportCount,
        'calmCount': calmCount,
        'insightCount': insightCount,
        'hugCount': hugCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // ===========================================================================
  // SERIALIZACIÓN
  // ===========================================================================

  static String _formatTimeAgo(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) {
      return 'Justo ahora';
    } else if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return 'Hace ${diff.inDays}d';
    } else {
      return 'Hace ${(diff.inDays / 7).floor()} sem';
    }
  }

  Map<String, dynamic> _postToFirestore(CommunityPost post) {
    final emojiMap = <String, List<String>>{};
    post.emojiReactions.forEach((emoji, users) {
      emojiMap[emoji] = users.toList();
    });

    final currentId = _firebaseService.currentUserId;
    final resolvedAuthorId = currentId.trim().isNotEmpty ? currentId.trim() : 'anonymous_student';

    return {
      'id': post.id,
      'authorId': resolvedAuthorId,
      'userId': resolvedAuthorId,
      'authorAlias': post.authorAlias,
      'authorRole': post.authorRole,
      'avatarName': post.avatar.name,
      'faculty': post.faculty,
      'tags': post.tags,
      'content': post.content,
      'moodCategory': post.moodCategory.name,
      'supportCount': post.supportCount,
      'calmCount': post.calmCount,
      'insightCount': post.insightCount,
      'hugCount': post.hugCount,
      'commentCount': post.commentCount,
      'userReactions': post.userReactions.toList(),
      'emojiReactions': emojiMap,
      'createdAtMillis': post.createdAt.millisecondsSinceEpoch,
    };
  }

  CommunityPost _postFromFirestore(
    Map<String, dynamic> data,
    String id,
    List<CommunityComment> comments, {
    String? currentUserId,
  }) {
    final avatarName = data['avatarName'] as String?;
    final avatar = CommunityAvatar.values.firstWhere(
      (a) => a.name == avatarName,
      orElse: () => CommunityAvatar.sprout,
    );

    final moodCategoryName = data['moodCategory'] as String?;
    final moodCategory = CommunityMoodCategory.values.firstWhere(
      (m) => m.name == moodCategoryName,
      orElse: () => CommunityMoodCategory.todo,
    );

    final rawEmojiMap = (data['emojiReactions'] as Map<String, dynamic>?) ?? {};
    final emojiReactions = <String, Set<String>>{};
    rawEmojiMap.forEach((key, val) {
      if (val is List) {
        emojiReactions[key] = val.map((e) => e.toString()).toSet();
      }
    });

    final createdMillis = data['createdAtMillis'] as int? ??
        (data['createdAt'] is Timestamp
            ? (data['createdAt'] as Timestamp).millisecondsSinceEpoch
            : DateTime.now().millisecondsSinceEpoch);

    final resolvedUser = (currentUserId != null && currentUserId.isNotEmpty)
        ? currentUserId
        : _firebaseService.currentUserId;

    final userReactions = <String>{};
    if (resolvedUser.isNotEmpty) {
      if (emojiReactions['❤️']?.contains(resolvedUser) == true ||
          emojiReactions['🤍']?.contains(resolvedUser) == true) {
        userReactions.add('support');
      }
      if (emojiReactions['🌿']?.contains(resolvedUser) == true) {
        userReactions.add('calm');
      }
      if (emojiReactions['💡']?.contains(resolvedUser) == true) {
        userReactions.add('insight');
      }
      if (emojiReactions['🫂']?.contains(resolvedUser) == true) {
        userReactions.add('hug');
      }
    } else {
      final rawUserReactions = data['userReactions'];
      if (rawUserReactions is List) {
        userReactions.addAll(rawUserReactions.map((e) => e.toString()));
      }
    }

    final rawTags = data['tags'];
    final tags = rawTags is List
        ? rawTags.map((e) => e.toString()).toList()
        : <String>[];

    final createdAtDate = DateTime.fromMillisecondsSinceEpoch(createdMillis);

    return CommunityPost(
      id: id,
      authorAlias: data['authorAlias'] as String? ?? 'Usuario anónimo',
      authorRole: data['authorRole'] as String? ?? 'Estudiante UC',
      avatar: avatar,
      faculty: data['faculty'] as String? ?? 'Campus San Joaquín',
      timeAgo: _formatTimeAgo(createdAtDate),
      tags: tags,
      content: data['content'] as String? ?? '',
      moodCategory: moodCategory,
      embeddedCard: const EmbeddedCardData(type: EmbeddedCardType.none, title: ''),
      supportCount: (data['supportCount'] as int?) ?? 0,
      calmCount: (data['calmCount'] as int?) ?? 0,
      insightCount: (data['insightCount'] as int?) ?? 0,
      hugCount: (data['hugCount'] as int?) ?? 0,
      commentCount: (data['commentCount'] as int?) ?? comments.length,
      userReactions: userReactions,
      comments: comments,
      emojiReactions: emojiReactions,
      createdAt: createdAtDate,
    );
  }

  Map<String, dynamic> _commentToFirestore(CommunityComment comment) {
    return {
      'id': comment.id,
      'postId': comment.postId,
      'authorId': comment.authorId,
      'authorName': comment.authorName,
      'authorAvatarUrl': comment.authorAvatarUrl,
      'content': comment.content,
      'createdAtMillis': comment.createdAt.millisecondsSinceEpoch,
    };
  }

  CommunityComment _commentFromFirestore(Map<String, dynamic> data, String id) {
    final createdMillis = data['createdAtMillis'] as int? ??
        (data['createdAt'] is Timestamp
            ? (data['createdAt'] as Timestamp).millisecondsSinceEpoch
            : DateTime.now().millisecondsSinceEpoch);

    return CommunityComment(
      id: id,
      postId: data['postId'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Usuario anónimo',
      authorAvatarUrl: data['authorAvatarUrl'] as String?,
      content: data['content'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdMillis),
    );
  }
}
