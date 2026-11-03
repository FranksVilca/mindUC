/// Categorías botánicas y de enfoque sereno para los logros orgánicos.
enum AchievementCategory {
  peace, // Semilla de Paz (Verde)
  mind, // Mente Serena (Lila)
  voice, // Voz Auténtica (Rosa)
  focus, // Foco Lúcido (Grisáceo / Salvia)
}

/// Entidad inmutable que representa un reconocimiento botánico del "Jardín de logros" (Principio III).
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
  }) {
    return OrganicAchievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isBloomed: isBloomed ?? this.isBloomed,
      currentProgress: currentProgress ?? this.currentProgress,
      maxProgress: maxProgress ?? this.maxProgress,
      progressLabel: progressLabel ?? this.progressLabel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganicAchievement &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          category == other.category &&
          isBloomed == other.isBloomed &&
          currentProgress == other.currentProgress &&
          maxProgress == other.maxProgress &&
          progressLabel == other.progressLabel;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      category.hashCode ^
      isBloomed.hashCode ^
      currentProgress.hashCode ^
      maxProgress.hashCode ^
      progressLabel.hashCode;
}

