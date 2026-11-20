import '../entities/community_comment.dart';
import '../entities/community_post.dart';

/// Interfaz abstracta del repositorio de comunidad (Capa de Dominio).
abstract class CommunityRepository {
  /// Obtiene la lista de publicaciones del foro
  Future<List<CommunityPost>> getPosts({String? currentUserId});

  /// Guarda una nueva publicación anónima
  Future<void> savePost(CommunityPost post);

  /// Conmuta la reacción estándar de un usuario a un hilo ('support', 'calm', 'insight', 'hug')
  Future<void> toggleReaction(String postId, String reactionKey, {String? userId});

  /// Agrega un comentario a una publicación
  Future<void> addComment({
    required String postId,
    required CommunityComment comment,
  });

  /// Conmuta cualquier reacción con emoji para un usuario evitando duplicados
  Future<void> toggleEmojiReaction({
    required String postId,
    required String emoji,
    required String userId,
  });
}
