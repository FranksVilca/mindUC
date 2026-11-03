# UI Contract: 009-community-forum

## Overview
Contrato de interfaz y componentes visuales para el foro anónimo compasivo de la comunidad UC.

## Controller Contract: `ICommunityController`

```dart
abstract class ICommunityController {
  /// Selecciona una categoría de filtro emocional ('Todo', 'Estrés académico', etc.)
  void selectFilter(CommunityMoodCategory filter);

  /// Conmuta la reacción del estudiante a una publicación ('support', 'calm', 'insight', 'hug')
  Future<void> toggleReaction(String postId, String reactionKey);

  /// Publica un nuevo hilo comunitario con un alias ficticio
  Future<void> createPost({
    required String authorAlias,
    required String authorRole,
    required CommunityAvatar avatar,
    required String faculty,
    required String content,
    required List<String> tags,
    required CommunityMoodCategory moodCategory,
  });
}
```

## Presentation Widgets Contract

### 1. `CommunityHeader`
- **Responsabilidad**: Barra de navegación superior con botón de retorno, títulos `"mindUC"` y `"Minduc — Comunidad"`, campana con punto rosa y avatar de perfil.
- **Parámetros**:
  - `VoidCallback onBack`
  - `VoidCallback? onNotification`
  - `VoidCallback? onProfile`

### 2. `CommunityBannerCard`
- **Responsabilidad**: Banner de "Comunidad UC Consciente", insignias "ESPACIO SEGURO UC" y "• Moderado con empatía", texto de bienvenida y aviso de identidad protegida con icono de escudo.

### 3. `MoodFilterChips`
- **Responsabilidad**: Selector horizontal de filtros por sentir ("Todo", "Estrés académico", "Desahogo y calma", "Hábito saludable", "Vulnerabilidad") y conteo de hilos activos ("5 hilos activos").
- **Parámetros**:
  - `required CommunityMoodCategory selectedFilter`
  - `required int activeThreadCount`
  - `required ValueChanged<CommunityMoodCategory> onFilterSelected`

### 4. `CommunityPostCard`
- **Responsabilidad**: Tarjeta completa de publicación comunitaria con avatar, alias, facultad, tiempo relativo, menú `⋮`, chips temáticos, texto de reflexión, tarjeta incrustada condicional y barra de reacciones interactivas.
- **Parámetros**:
  - `required CommunityPost post`
  - `required void Function(String reactionKey) onReactionTap`
  - `VoidCallback? onEmbeddedActionTap`
  - `VoidCallback? onMenuTap`

### 5. `CommunityPostCreateModal`
- **Responsabilidad**: Hoja modal para redactar y publicar una nueva reflexión comunitaria sin exponer datos personales.
- **Método de invocación**:
  ```dart
  static Future<void> show(
    BuildContext context, {
    required void Function(
      String authorAlias,
      String authorRole,
      CommunityAvatar avatar,
      String faculty,
      String content,
      List<String> tags,
      CommunityMoodCategory moodCategory,
    ) onPublish,
  });
  ```
