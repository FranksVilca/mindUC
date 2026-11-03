import 'active_streak.dart';
import 'organic_achievement.dart';
import 'weekly_intention.dart';
import 'weekly_pause_metrics.dart';

/// Estado inmutable consolidado del panel de Progreso & Florecimiento.
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
    this.quote =
        '“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”',
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
  }) {
    return ProgressSummaryState(
      streak: streak ?? this.streak,
      metrics: metrics ?? this.metrics,
      achievements: achievements ?? this.achievements,
      intentions: intentions ?? this.intentions,
      quote: quote ?? this.quote,
      quoteSubtitle: quoteSubtitle ?? this.quoteSubtitle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressSummaryState &&
          runtimeType == other.runtimeType &&
          streak == other.streak &&
          metrics == other.metrics &&
          quote == other.quote &&
          quoteSubtitle == other.quoteSubtitle;

  @override
  int get hashCode =>
      streak.hashCode ^
      metrics.hashCode ^
      quote.hashCode ^
      quoteSubtitle.hashCode;
}

