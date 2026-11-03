import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/progress_gamification/data/datasources/local_progress_datasource.dart';
import 'package:minduc/features/progress_gamification/data/repositories/local_progress_repository_impl.dart';
import 'package:minduc/features/progress_gamification/domain/entities/organic_achievement.dart';
import 'package:minduc/features/progress_gamification/domain/entities/weekly_intention.dart';
import 'package:minduc/features/progress_gamification/presentation/controllers/progress_controller.dart';

void main() {
  group('ProgressNotifier Unit Tests', () {
    late LocalProgressDataSource dataSource;
    late LocalProgressRepositoryImpl repository;
    late ProgressNotifier notifier;

    setUp(() {
      dataSource = LocalProgressDataSource();
      repository = LocalProgressRepositoryImpl(dataSource: dataSource);
      notifier = ProgressNotifier(repository);
    });

    test('initial state loads 7 days streak and Figma mock pause metrics', () {
      final state = notifier.state;

      // Racha compasiva de 7 días
      expect(state.streak.daysCount, 7);
      expect(
        state.streak.message,
        'Tu brote de serenidad floreció hoy con tu pausa matutina.',
      );
      expect(state.streak.completedDays.length, 7);
      expect(state.streak.isDayCompleted(6), isTrue);

      // Momentos de pausa semanales
      expect(state.metrics.breathingMinutes, 145);
      expect(state.metrics.pomodoroSessions, 12);
      expect(state.metrics.journalEntriesCount, 9);
      expect(state.metrics.balancePercentage, 85);

      // Jardín de logros (3 de 4)
      expect(state.totalAchievements, 4);
      expect(state.bloomedCount, 3);

      // Intenciones de la semana
      expect(state.intentions.length, 3);
      expect(state.intentions.first.isCompleted, isTrue);
    });

    test('toggleIntention updates units and completion status reactively', () async {
      // Intención 2: "Tomar un paseo consciente de 10 min", inicial: 2 / 3
      final initialInt2 = notifier.state.intentions[1];
      expect(initialInt2.currentUnits, 2);
      expect(initialInt2.isCompleted, isFalse);

      await notifier.toggleIntention('int-2');

      final updatedInt2 = notifier.state.intentions[1];
      expect(updatedInt2.currentUnits, 3);
      expect(updatedInt2.isCompleted, isTrue);

      // Tocar nuevamente revierte a estado previo
      await notifier.toggleIntention('int-2');
      final revertedInt2 = notifier.state.intentions[1];
      expect(revertedInt2.currentUnits, 2);
      expect(revertedInt2.isCompleted, isFalse);
    });

    test('refresh reloads latest summary from repository', () async {
      await notifier.toggleIntention('int-2');
      expect(notifier.state.intentions[1].isCompleted, isTrue);

      await notifier.refresh();
      expect(notifier.state.intentions[1].isCompleted, isTrue);
    });
  });

  group('Progress Domain Value Objects Tests', () {
    test('OrganicAchievement calculates progressRatio correctly', () {
      const achievement = OrganicAchievement(
        id: 'ach-4',
        title: 'Foco Lúcido',
        description: '5h en modo concentración plena',
        category: AchievementCategory.focus,
        isBloomed: false,
        currentProgress: 4.0,
        maxProgress: 5.0,
      );

      expect(achievement.progressRatio, 0.8);
    });

    test('WeeklyIntention calculates progressRatio correctly', () {
      const intention = WeeklyIntention(
        id: 'int-2',
        title: 'Tomar un paseo',
        currentUnits: 2,
        targetUnits: 4,
        unitLabel: 'días',
        isCompleted: false,
        iconType: IntentionIconType.walk,
      );

      expect(intention.progressRatio, 0.5);
    });
  });
}

