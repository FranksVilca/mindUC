import '../entities/community_post.dart';

/// Interfaz abstracta del repositorio de comunidad (Capa de Dominio).
abstract class CommunityRepository {
  /// Obtiene la lista de publicaciones del foro
  Future<List<CommunityPost>> getPosts();

  /// Guarda una nueva publicación anónima
  Future<void> savePost(CommunityPost post);

  /// Conmuta la reacción de un usuario a un hilo
  Future<void> toggleReaction(String postId, String reactionKey);
}
