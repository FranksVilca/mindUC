# Data Model: 009-community-forum

## Entities & Value Objects (Domain Layer)

### 1. `CommunityAvatar` (Enum)
Tipos de avatares ficticios botánicos y animales serenos con sus iconos y fondos asociados.

```dart
enum CommunityAvatar {
  moon(
    icon: Icons.nightlight_round,
    backgroundColor: Color(0xFFE8E5F4),
    iconColor: Color(0xFF6B6396),
  ),
  sprout(
    icon: Icons.eco_rounded,
    backgroundColor: Color(0xFFE2F0E7),
    iconColor: Color(0xFF3B5648),
  ),
  raindrop(
    icon: Icons.water_drop_rounded,
    backgroundColor: Color(0xFFE8EEF5),
    iconColor: Color(0xFF4C6B8B),
  ),
  flower(
    icon: Icons.spa_rounded,
    backgroundColor: Color(0xFFFDECE8),
    iconColor: Color(0xFFD66885),
  );

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const CommunityAvatar({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}
```

### 2. `CommunityMoodCategory` (Enum)
Categorías para clasificación y filtrado de hilos.

```dart
enum CommunityMoodCategory {
  todo(displayName: 'Todo'),
  estresAcademico(displayName: 'Estrés académico'),
  desahogoCalma(displayName: 'Desahogo y calma'),
  habitoSaludable(displayName: 'Hábito saludable'),
  vulnerabilidad(displayName: 'Vulnerabilidad');

  final String displayName;
  const CommunityMoodCategory({required this.displayName});
}
```

### 3. `EmbeddedCardType` (Enum) & `EmbeddedCardData` (Value Object)
Tipo de complemento contextual mostrado dentro de la tarjeta de la publicación.

```dart
enum EmbeddedCardType {
  none,
  insightNotice,   // "5 compañeros han tomado una pausa respiratoria tras leer esto."
  breathingPrompt, // "Guía 4–7–8 recomendada — 3 min · Sesión de calma" + Botón "Probar"
  topReply,        // "🌱 Respuesta más apoyada: ..."
}

class EmbeddedCardData {
  final EmbeddedCardType type;
  final String title;
  final String subtitle;
  final String? actionLabel;

  const EmbeddedCardData({
    required this.type,
    required this.title,
    this.subtitle = '',
    this.actionLabel,
  });
}
```

### 4. `CommunityPost` (Domain Entity)
Entidad inmutable que representa un hilo de discusión en la comunidad.

```dart
class CommunityPost {
  final String id;
  final String authorAlias;       // ej. "@BúhoCurioso"
  final String authorRole;        // ej. "Búho Sereno"
  final CommunityAvatar avatar;
  final String faculty;           // ej. "Ingeniería", "Medicina", "Humanidades"
  final String timeAgo;           // ej. "Hace 2h", "Hace 4h"
  final List<String> tags;        // ej. ["Necesito desahogo", "Exámenes"]
  final String content;
  final CommunityMoodCategory moodCategory;
  final EmbeddedCardData embeddedCard;
  final int supportCount;         // 🤍❤️
  final int calmCount;            // 🌿
  final int insightCount;         // 💡
  final int hugCount;              // 🫂
  final int commentCount;         // 💬
  final Set<String> userReactions;// {"support", "calm"}
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
    this.embeddedCard = const EmbeddedCardData(type: EmbeddedCardType.none, title: ''),
    this.supportCount = 0,
    this.calmCount = 0,
    this.insightCount = 0,
    this.hugCount = 0,
    this.commentCount = 0,
    this.userReactions = const {},
    required this.createdAt,
  });

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
    DateTime? createdAt,
  });
}
```

### 5. `CommunityState` (Riverpod State Model)
```dart
class CommunityState {
  final CommunityMoodCategory selectedFilter;
  final List<CommunityPost> allPosts;
  final bool isLoading;

  const CommunityState({
    this.selectedFilter = CommunityMoodCategory.todo,
    this.allPosts = const [],
    this.isLoading = false,
  });

  /// Lista filtrada según la categoría seleccionada
  List<CommunityPost> get filteredPosts;

  int get activeThreadCount => allPosts.length;

  CommunityState copyWith({
    CommunityMoodCategory? selectedFilter,
    List<CommunityPost>? allPosts,
    bool? isLoading,
  });
}
```

## Repositories & Data Sources

### `CommunityRepository` (Domain Interface)
```dart
abstract class CommunityRepository {
  Future<List<CommunityPost>> getPosts();
  Future<void> savePost(CommunityPost post);
  Future<void> toggleReaction(String postId, String reactionKey);
}
```

### `LocalCommunityDataSource` (Data Layer)
Almacena las publicaciones localmente precargando los 3 hilos de Figma (`@BúhoCurioso`, `@BroteCalmo`, `@LluviaSuave`) y permitiendo agregar nuevos hilos y reaccionar.
