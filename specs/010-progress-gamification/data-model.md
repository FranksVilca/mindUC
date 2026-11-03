# Data Model: 010-progress-gamification

## Overview
Modelos de dominio inmutables, Value Objects y contratos de repositorio para el módulo de Progreso & Florecimiento de mindUC (Principio III: Métricas Compasivas).

---

## Domain Entities & Value Objects

### 1. `ActiveStreak` (Value Object)
Representa la racha activa de autocuidado del estudiante sin penalización por pausas.

```dart
class ActiveStreak {
  final int daysCount;
  final String message;
  final List<bool> completedDays; // Longitud 7: [L, M, X, J, V, S, D]
  final int currentDayIndex; // 0..6

  const ActiveStreak({
    required this.daysCount,
    required this.message,
    required this.completedDays,
    required this.currentDayIndex,
  });

  bool isDayCompleted(int index) =>
      index >= 0 && index < completedDays.length ? completedDays[index] : false;

  ActiveStreak copyWith({
    int? daysCount,
    String? message,
    List<bool>? completedDays,
    int? currentDayIndex,
  });
}
```

---

### 2. `WeeklyPauseMetrics` (Value Object)
Representa el resumen semanal de momentos de bienestar y calma.

```dart
class WeeklyPauseMetrics {
  final int breathingMinutes;
  final int pomodoroSessions;
  final int journalEntriesCount;
  final int balancePercentage;

  const WeeklyPauseMetrics({
    required this.breathingMinutes,
    required this.pomodoroSessions,
    required this.journalEntriesCount,
    required this.balancePercentage,
  });

  WeeklyPauseMetrics copyWith({
    int? breathingMinutes,
    int? pomodoroSessions,
    int? journalEntriesCount,
    int? balancePercentage,
  });
}
```

---

### 3. `AchievementCategory` (Enum) & `OrganicAchievement` (Entity)
Categorías y reconocimientos del "Jardín de logros".

```dart
enum AchievementCategory {
  peace,  // Semilla de Paz (Verde)
  mind,   // Mente Serena (Lila)
  voice,  // Voz Auténtica (Rosa)
  focus,  // Foco Lúcido (Grisáceo / Salvia)
}

class OrganicAchievement {
  final String id;
  final String title;
  final String description;
  final AchievementCategory category;
  final bool isBloomed;
  final double currentProgress;
  final double maxProgress;
  final String? progressLabel;

  const OrganicAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isBloomed,
    required this.currentProgress,
    required this.maxProgress,
    this.progressLabel,
  });

  double get progressRatio =>
      maxProgress > 0 ? (currentProgress / maxProgress).clamp(0.0, 1.0) : 0.0;

  OrganicAchievement copyWith({
    String? id,
    String? title,
    String? description,
    AchievementCategory? category,
    bool? isBloomed,
    double? currentProgress,
    double? maxProgress,
    String? progressLabel,
  });
}
```

---

### 4. `IntentionIconType` (Enum) & `WeeklyIntention` (Entity)
Metas amables semanales con avance interactivo.

```dart
enum IntentionIconType {
  pauses,   // Pausas activas (Checkmark / descanso)
  walk,     // Paseo consciente (Reloj de arena / pasos)
  screens,  // Desconexión de pantallas (Luna / sueño)
}

class WeeklyIntention {
  final String id;
  final String title;
  final int currentUnits;
  final int targetUnits;
  final String unitLabel;
  final bool isCompleted;
  final IntentionIconType iconType;

  const WeeklyIntention({
    required this.id,
    required this.title,
    required this.currentUnits,
    required this.targetUnits,
    required this.unitLabel,
    required this.isCompleted,
    required this.iconType,
  });

  double get progressRatio =>
      targetUnits > 0 ? (currentUnits / targetUnits).clamp(0.0, 1.0) : 0.0;

  WeeklyIntention copyWith({
    String? id,
    String? title,
    int? currentUnits,
    int? targetUnits,
    String? unitLabel,
    bool? isCompleted,
    IntentionIconType? iconType,
  });
}
```

---

### 5. `ProgressSummaryState` (Entity)
Estado compuesto global del panel de progreso.

```dart
class ProgressSummaryState {
  final ActiveStreak streak;
  final WeeklyPauseMetrics metrics;
  final List<OrganicAchievement> achievements;
  final List<WeeklyIntention> intentions;
  final String quote;
  final String quoteSubtitle;

  const ProgressSummaryState({
    required this.streak,
    required this.metrics,
    required this.achievements,
    required this.intentions,
    this.quote = '“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”',
    this.quoteSubtitle = 'Recordatorio de autocompasión',
  });

  int get bloomedCount => achievements.where((a) => a.isBloomed).length;
  int get totalAchievements => achievements.length;

  ProgressSummaryState copyWith({
    ActiveStreak? streak,
    WeeklyPauseMetrics? metrics,
    List<OrganicAchievement>? achievements,
    List<WeeklyIntention>? intentions,
    String? quote,
    String? quoteSubtitle,
  });
}
```

---

## Repository Contract: `ProgressRepository`

```dart
abstract class ProgressRepository {
  /// Obtiene el estado consolidado de progreso del estudiante
  Future<ProgressSummaryState> getProgressSummary();

  /// Incrementa o conmuta el avance de una intención semanal
  Future<ProgressSummaryState> toggleIntentionProgress(String intentionId);
}
```

