import 'package:flutter/foundation.dart';
import '../../domain/entities/community_avatar.dart';
import '../../domain/entities/community_comment.dart';
import '../../domain/entities/community_mood_category.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/embedded_card_data.dart';

/// Fuente de datos local en el dispositivo para la comunidad UC (Principio V).
/// Almacena hilos, comentarios y reacciones con persistencia compartida en memoria
/// sin exponer identidades reales del estudiante.
class LocalCommunityDataSource {
  static final List<CommunityPost> _sharedPosts = [];

  LocalCommunityDataSource({List<CommunityPost>? initialPosts}) {
    if (_sharedPosts.isEmpty) {
      if (initialPosts != null) {
        _sharedPosts.addAll(initialPosts);
      } else {
        _sharedPosts.addAll(_mockInitialPosts);
      }
    } else if (initialPosts != null) {
      for (final p in initialPosts) {
        if (!_sharedPosts.any((sp) => sp.id == p.id)) {
          _sharedPosts.add(p);
        }
      }
    }
  }

  /// Limpia la memoria compartida entre ejecuciones de pruebas unitarias
  @visibleForTesting
  static void resetForTesting() {
    _sharedPosts.clear();
  }

  List<CommunityPost> get _posts => _sharedPosts;

  /// Publicaciones iniciales semilla para arranque inmediato offline-first
  static List<CommunityPost> get mockInitialPosts => _mockInitialPosts;

  static List<CommunityPost> get _mockInitialPosts {
    final now = DateTime.now();

    return [
      CommunityPost(
        id: 'post-1',
        authorAlias: '@BúhoCurioso',
        authorRole: 'Búho Sereno',
        avatar: CommunityAvatar.moon,
        faculty: 'Ingeniería',
        timeAgo: 'Hace 2h',
        tags: const ['• Necesito desahogo', 'Exámenes'],
        content:
            'Siento que esta semana de exámenes parciales me está superando. Recordatorio para mí y para ustedes: una nota no define nuestro valor como personas. Respiremos hondo 🤍',
        moodCategory: CommunityMoodCategory.estresAcademico,
        embeddedCard: const EmbeddedCardData(
          type: EmbeddedCardType.insightNotice,
          title: '5 compañeros han tomado una pausa respiratoria tras leer esto.',
        ),
        supportCount: 42,
        calmCount: 28,
        insightCount: 9,
        hugCount: 0,
        commentCount: 2,
        comments: [
          CommunityComment(
            id: 'c-1-1',
            postId: 'post-1',
            authorId: 'usr_rodrigo',
            authorName: 'Rodrigo Morales',
            content: 'Mucho ánimo, todos pasamos por ese momento. ¡Toma una pausa!',
            createdAt: now.subtract(const Duration(hours: 1, minutes: 20)),
          ),
          CommunityComment(
            id: 'c-1-2',
            postId: 'post-1',
            authorId: 'usr_sofia',
            authorName: 'Sofía Valenzuela',
            content: 'Gracias por el recordatorio, realmente lo necesitaba hoy 🌿',
            createdAt: now.subtract(const Duration(minutes: 45)),
          ),
        ],
        emojiReactions: const {
          '🤍': {'mock_1', 'mock_2'},
          '🌿': {'mock_3'},
        },
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      CommunityPost(
        id: 'post-2',
        authorAlias: '@BroteCalmo',
        authorRole: 'Brote Verde',
        avatar: CommunityAvatar.sprout,
        faculty: 'Medicina',
        timeAgo: 'Hace 4h',
        tags: const ['• Hábito saludable', 'Mindfulness'],
        content:
            'Hice la pausa de respiración 4–7–8 antes de entrar a clases hoy y la diferencia fue increíble. ¡Mucho ánimo a todos los que están rindiendo hoy!',
        moodCategory: CommunityMoodCategory.habitoSaludable,
        embeddedCard: const EmbeddedCardData(
          type: EmbeddedCardType.breathingPrompt,
          title: 'Guía 4–7–8 recomendada',
          subtitle: '3 min · Sesión de calma',
          actionLabel: 'Probar',
        ),
        supportCount: 65,
        calmCount: 41,
        insightCount: 0,
        hugCount: 0,
        commentCount: 1,
        comments: [
          CommunityComment(
            id: 'c-2-1',
            postId: 'post-2',
            authorId: 'usr_matias',
            authorName: 'Matías Silva',
            content: 'La técnica 4-7-8 es de mis favoritas para antes de entrar a certámenes.',
            createdAt: now.subtract(const Duration(hours: 2)),
          ),
        ],
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      CommunityPost(
        id: 'post-3',
        authorAlias: '@LluviaSuave',
        authorRole: 'Brizna Serena',
        avatar: CommunityAvatar.raindrop,
        faculty: 'Humanidades',
        timeAgo: 'Hace 6h',
        tags: const ['• Vulnerabilidad', 'Autoexigencia'],
        content:
            '¿Alguien más siente síndrome del impostor este semestre? Me cuesta celebrar los pequeños logros y siento que nunca es suficiente.',
        moodCategory: CommunityMoodCategory.vulnerabilidad,
        embeddedCard: const EmbeddedCardData(
          type: EmbeddedCardType.topReply,
          title: 'Respuesta más apoyada',
          subtitle:
              '“¡Nos pasa a muchos, no estás sola! Estás exactamente donde mereces estar. Paso a paso 🌻”',
        ),
        supportCount: 53,
        calmCount: 37,
        insightCount: 0,
        hugCount: 19,
        commentCount: 1,
        comments: [
          CommunityComment(
            id: 'c-3-1',
            postId: 'post-3',
            authorId: 'usr_camila',
            authorName: 'Camila Soto',
            content: '¡Nos pasa a muchos! Estás exactamente donde mereces estar. Paso a paso 🌻',
            createdAt: now.subtract(const Duration(hours: 3)),
          ),
        ],
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
    ];
  }

  /// Retorna una copia de las publicaciones
  Future<List<CommunityPost>> getPosts() async {
    return List<CommunityPost>.from(_posts);
  }

  /// Inserta una nueva publicación en la cima de la cronología
  Future<void> savePost(CommunityPost post) async {
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index >= 0) {
      _posts[index] = post;
    } else {
      _posts.insert(0, post);
    }
  }

  /// Sincroniza un lote de publicaciones en memoria optimizando la búsqueda por ID
  Future<void> savePosts(List<CommunityPost> posts) async {
    if (posts.isEmpty) return;
    final existingMap = {for (int i = 0; i < _posts.length; i++) _posts[i].id: i};
    final toInsert = <CommunityPost>[];

    for (final post in posts) {
      final idx = existingMap[post.id];
      if (idx != null) {
        _posts[idx] = post;
      } else {
        toInsert.add(post);
      }
    }
    if (toInsert.isNotEmpty) {
      _posts.insertAll(0, toInsert);
    }
  }

  /// Agrega un comentario a una publicación específica
  Future<void> addComment({
    required String postId,
    required CommunityComment comment,
  }) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index >= 0) {
      final post = _posts[index];
      final updatedComments = List<CommunityComment>.from(post.comments)..add(comment);
      _posts[index] = post.copyWith(
        comments: updatedComments,
        commentCount: updatedComments.length,
      );
    }
  }

  /// Conmuta cualquier emoji para un usuario garantizando que no haya duplicados
  Future<void> toggleEmojiReaction({
    required String postId,
    required String emoji,
    required String userId,
  }) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index >= 0) {
      final post = _posts[index];
      final currentMap = Map<String, Set<String>>.from(
        post.emojiReactions.map((k, v) => MapEntry(k, Set<String>.from(v))),
      );
      final userSet = currentMap.putIfAbsent(emoji, () => <String>{});

      final wasPresent = userSet.contains(userId);
      if (wasPresent) {
        userSet.remove(userId);
        if (userSet.isEmpty) {
          currentMap.remove(emoji);
        }
      } else {
        userSet.add(userId);
      }

      int support = post.supportCount;
      int calm = post.calmCount;
      int insight = post.insightCount;
      int hug = post.hugCount;
      final currentReactions = Set<String>.from(post.userReactions);

      if (emoji == '🤍' || emoji == '❤️') {
        if (!wasPresent) {
          currentReactions.add('support');
          support += 1;
        } else {
          currentReactions.remove('support');
          support = (support - 1).clamp(0, 9999);
        }
      } else if (emoji == '🌿') {
        if (!wasPresent) {
          currentReactions.add('calm');
          calm += 1;
        } else {
          currentReactions.remove('calm');
          calm = (calm - 1).clamp(0, 9999);
        }
      } else if (emoji == '💡') {
        if (!wasPresent) {
          currentReactions.add('insight');
          insight += 1;
        } else {
          currentReactions.remove('insight');
          insight = (insight - 1).clamp(0, 9999);
        }
      } else if (emoji == '🫂') {
        if (!wasPresent) {
          currentReactions.add('hug');
          hug += 1;
        } else {
          currentReactions.remove('hug');
          hug = (hug - 1).clamp(0, 9999);
        }
      }

      _posts[index] = post.copyWith(
        emojiReactions: currentMap,
        userReactions: currentReactions,
        supportCount: support,
        calmCount: calm,
        insightCount: insight,
        hugCount: hug,
      );
    }
  }

  /// Conmuta la reacción estándar del estudiante para una publicación
  Future<void> toggleReaction(String postId, String reactionKey, {String? userId}) async {
    final emojiMap = {
      'support': '🤍',
      'calm': '🌿',
      'insight': '💡',
      'hug': '🫂',
    };
    final emoji = emojiMap[reactionKey] ?? reactionKey;
    await toggleEmojiReaction(
      postId: postId,
      emoji: emoji,
      userId: (userId != null && userId.isNotEmpty) ? userId : 'current_user_local',
    );
  }
}
