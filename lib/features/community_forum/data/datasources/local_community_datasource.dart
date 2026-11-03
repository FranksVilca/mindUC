import '../../domain/entities/community_avatar.dart';
import '../../domain/entities/community_mood_category.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/embedded_card_data.dart';

/// Fuente de datos local en el dispositivo para la comunidad UC (Principio V).
/// Almacena hilos y reacciones en memoria sin exponer identidades reales del estudiante.
class LocalCommunityDataSource {
  LocalCommunityDataSource({List<CommunityPost>? initialPosts}) {
    if (initialPosts != null) {
      _posts.addAll(initialPosts);
    } else {
      _posts.addAll(_mockInitialPosts);
    }
  }

  final List<CommunityPost> _posts = [];

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
        commentCount: 14,
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
        commentCount: 8,
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
        commentCount: 22,
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

  /// Conmuta la reacción del estudiante para una publicación
  Future<void> toggleReaction(String postId, String reactionKey) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index >= 0) {
      final post = _posts[index];
      final currentReactions = Set<String>.from(post.userReactions);
      final hasReacted = currentReactions.contains(reactionKey);

      int support = post.supportCount;
      int calm = post.calmCount;
      int insight = post.insightCount;
      int hug = post.hugCount;

      if (hasReacted) {
        currentReactions.remove(reactionKey);
        if (reactionKey == 'support') support = (support - 1).clamp(0, 9999);
        if (reactionKey == 'calm') calm = (calm - 1).clamp(0, 9999);
        if (reactionKey == 'insight') insight = (insight - 1).clamp(0, 9999);
        if (reactionKey == 'hug') hug = (hug - 1).clamp(0, 9999);
      } else {
        currentReactions.add(reactionKey);
        if (reactionKey == 'support') support += 1;
        if (reactionKey == 'calm') calm += 1;
        if (reactionKey == 'insight') insight += 1;
        if (reactionKey == 'hug') hug += 1;
      }

      _posts[index] = post.copyWith(
        supportCount: support,
        calmCount: calm,
        insightCount: insight,
        hugCount: hug,
        userReactions: currentReactions,
      );
    }
  }
}
