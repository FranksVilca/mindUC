import 'wellness_suggested_exercise.dart';
import 'wellness_tool_item.dart';

/// Modelo de estado inmutable para el Hub de Bienestar.
class WellnessState {
  final WellnessSuggestedExercise suggestedExercise;
  final List<WellnessToolItem> tools;
  final bool isSanctuaryActive;

  const WellnessState({
    this.suggestedExercise = WellnessSuggestedExercise.defaultDaily,
    this.tools = WellnessToolItem.defaultTools,
    this.isSanctuaryActive = true,
  });

  WellnessState copyWith({
    WellnessSuggestedExercise? suggestedExercise,
    List<WellnessToolItem>? tools,
    bool? isSanctuaryActive,
  }) {
    return WellnessState(
      suggestedExercise: suggestedExercise ?? this.suggestedExercise,
      tools: tools ?? this.tools,
      isSanctuaryActive: isSanctuaryActive ?? this.isSanctuaryActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellnessState &&
          runtimeType == other.runtimeType &&
          suggestedExercise == other.suggestedExercise &&
          isSanctuaryActive == other.isSanctuaryActive;

  @override
  int get hashCode => suggestedExercise.hashCode ^ isSanctuaryActive.hashCode;
}
