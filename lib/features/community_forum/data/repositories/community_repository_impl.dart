import 'package:flutter/foundation.dart';
import '../../../../core/firebase/firebase_initializer.dart';
import '../../domain/entities/community_comment.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/firestore_community_datasource.dart';
import '../datasources/local_community_datasource.dart';

/// Implementación del repositorio de comunidad con persistencia Cloud Firestore
/// y fallback local resiliente.
class CommunityRepositoryImpl implements CommunityRepository {
  final FirestoreCommunityDataSource _firestoreDataSource;
  final LocalCommunityDataSource _localDataSource;

  CommunityRepositoryImpl({
    FirestoreCommunityDataSource? firestoreDataSource,
    LocalCommunityDataSource? localDataSource,
  })  : _firestoreDataSource =
            firestoreDataSource ?? FirestoreCommunityDataSource(),
        _localDataSource = localDataSource ?? LocalCommunityDataSource();

  bool get _useFirestore => FirebaseInitializer.isInitialized;

  @override
  Future<List<CommunityPost>> getPosts({String? currentUserId}) async {
    if (_useFirestore) {
      try {
        final firestorePosts = await _firestoreDataSource.getPosts(currentUserId: currentUserId);
        if (firestorePosts.isNotEmpty) {
          // Si Firestore tiene posts, combinamos con los posts semilla locales
          // que falten por ID para preservar la base comunitaria inicial UC.
          final localPosts = await _localDataSource.getPosts();
          final existingIds = firestorePosts.map((p) => p.id).toSet();
          final missingSeeds =
              localPosts.where((p) => !existingIds.contains(p.id)).toList();

          final combined = [...firestorePosts, ...missingSeeds];

          // Sincronizamos los posts remotos en la memoria local por lote
          await _localDataSource.savePosts(firestorePosts);
          return combined;
        } else {
          // Si Firestore está vacío (primer arranque con backend), sembramos los posts mock iniciales
          final localPosts = await _localDataSource.getPosts();
          for (final p in localPosts) {
            try {
              await _firestoreDataSource.savePost(p);
            } catch (e) {
              debugPrint('[CommunityRepositoryImpl] Aviso al sembrar post en Firestore: $e');
            }
          }
          return localPosts;
        }
      } catch (e, st) {
        debugPrint('[CommunityRepositoryImpl] Falló lectura de Firestore, usando caché local: $e\n$st');
      }
    }
    return _localDataSource.getPosts();
  }

  @override
  Future<void> savePost(CommunityPost post) async {
    await _localDataSource.savePost(post);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.savePost(post);
        debugPrint('[CommunityRepositoryImpl] Publicación ${post.id} sincronizada en Cloud Firestore.');
      } catch (e, st) {
        debugPrint('[CommunityRepositoryImpl] Falló guardado en Cloud Firestore: $e\n$st');
      }
    }
  }

  @override
  Future<void> toggleReaction(String postId, String reactionKey, {String? userId}) async {
    await _localDataSource.toggleReaction(postId, reactionKey, userId: userId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.toggleReaction(postId, reactionKey, userId: userId);
      } catch (e) {
        debugPrint('[CommunityRepositoryImpl] Error en toggleReaction Firestore: $e');
      }
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required CommunityComment comment,
  }) async {
    await _localDataSource.addComment(postId: postId, comment: comment);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.addComment(
          postId: postId,
          comment: comment,
        );
      } catch (e) {
        debugPrint('[CommunityRepositoryImpl] Error en addComment Firestore: $e');
      }
    }
  }

  @override
  Future<void> toggleEmojiReaction({
    required String postId,
    required String emoji,
    required String userId,
  }) async {
    await _localDataSource.toggleEmojiReaction(
      postId: postId,
      emoji: emoji,
      userId: userId,
    );
    if (_useFirestore) {
      try {
        await _firestoreDataSource.toggleEmojiReaction(
          postId: postId,
          emoji: emoji,
          userId: userId,
        );
      } catch (e) {
        debugPrint('[CommunityRepositoryImpl] Error en toggleEmojiReaction Firestore: $e');
      }
    }
  }
}
