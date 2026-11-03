import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/wellness/domain/entities/wellness_suggested_exercise.dart';
import 'package:minduc/features/wellness/presentation/controllers/wellness_controller.dart';

void main() {
  group('WellnessNotifier Unit Tests', () {
    late WellnessNotifier notifier;

    setUp(() {
      notifier = WellnessNotifier();
    });

    test('initial state has default suggested exercise, 4 tools and sanctuary mode active', () {
      final state = notifier.state;

      expect(state.isSanctuaryActive, isTrue);
      expect(state.suggestedExercise.id, 'suggested_breath_478');
      expect(state.suggestedExercise.techniqueId, 'relaxing_478');
      expect(state.suggestedExercise.durationSeconds, 300);
      expect(state.tools.length, 4);

      // Verify the 4 tools
      final toolIds = state.tools.map((t) => t.id).toList();
      expect(toolIds, containsAll(['breathing', 'journal', 'ai_assistant', 'pomodoro']));
    });

    test('toggleSanctuaryMode inverts sanctuary state', () {
      expect(notifier.state.isSanctuaryActive, isTrue);

      notifier.toggleSanctuaryMode();
      expect(notifier.state.isSanctuaryActive, isFalse);

      notifier.toggleSanctuaryMode();
      expect(notifier.state.isSanctuaryActive, isTrue);
    });

    test('setSuggestedExercise updates current exercise in state', () {
      const customExercise = WellnessSuggestedExercise(
        id: 'box_breath_custom',
        categoryLabel: 'RECOMENDADO PARA ESTUDIO',
        title: 'Respiración Cuadrada 4-4-4',
        description: 'Enfoque mental antes de clases',
        techniqueId: 'box_444',
        durationSeconds: 180,
        statusLabel: 'Enfoque guiado',
        actionLabel: 'Comenzar (3 min)',
      );

      notifier.setSuggestedExercise(customExercise);

      expect(notifier.state.suggestedExercise.id, 'box_breath_custom');
      expect(notifier.state.suggestedExercise.durationSeconds, 180);
    });
  });
}
