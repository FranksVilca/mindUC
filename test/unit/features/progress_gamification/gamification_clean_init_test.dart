import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/progress_gamification/data/datasources/local_progress_datasource.dart';
import 'package:minduc/features/progress_gamification/data/repositories/local_progress_repository_impl.dart';

void main() {
  setUp(() {
    LocalProgressDataSource.clearStates();
  });

  tearDown(() {
    LocalProgressDataSource.clearStates();
  });

  group('Gamificación en blanco para cuentas nuevas', () {
    test('Cuenta nueva inicia completamente limpia en ceros sin logros ni metas heredadas', () async {
      final dataSource = LocalProgressDataSource();
      final repository = LocalProgressRepositoryImpl(dataSource: dataSource);

      // Usuario nuevo
      final newSummary = await repository.getProgressSummary('new_student_alpha');

      expect(newSummary.streak.daysCount, 0, reason: 'Racha debe iniciar en 0');
      expect(newSummary.metrics.pomodoroSessions, 0, reason: 'Sesiones deben iniciar en 0');
      expect(newSummary.metrics.breathingMinutes, 0, reason: 'Minutos de respiración deben iniciar en 0');
      expect(newSummary.metrics.journalEntriesCount, 0, reason: 'Entradas de diario deben iniciar en 0');
      expect(newSummary.metrics.balancePercentage, 0);

      // Logros e intenciones deben estar completamente limpios
      expect(newSummary.achievements, isEmpty,
          reason: 'No se deben mostrar logros ni insignias heredadas para cuentas nuevas');
      expect(newSummary.intentions, isEmpty,
          reason: 'No se deben mostrar metas ni intenciones heredadas para cuentas nuevas');
      expect(newSummary.bloomedCount, 0);
      expect(newSummary.totalAchievements, 0);
    });

    test('Logros se generan y actualizan dinámicamente con la actividad real del usuario', () async {
      final dataSource = LocalProgressDataSource();
      final repository = LocalProgressRepositoryImpl(dataSource: dataSource);

      const userId = 'active_student_beta';

      // 1. Inicia en ceros
      var summary = await repository.getProgressSummary(userId);
      expect(summary.achievements, isEmpty);

      // 2. Realiza sesión de Pomodoro
      await repository.incrementPomodoroSession(userId);
      summary = await repository.getProgressSummary(userId);
      expect(summary.metrics.pomodoroSessions, 1);
      expect(summary.achievements.length, 1);
      expect(summary.achievements.first.id, 'ach-4');
      expect(summary.achievements.first.title, 'Foco Lúcido');
      expect(summary.achievements.first.currentProgress, 0.5);

      // 3. Realiza minutos de respiración guiada
      await repository.recordBreathingMinutes(20, userId);
      summary = await repository.getProgressSummary(userId);
      expect(summary.metrics.breathingMinutes, 20);
      expect(summary.achievements.length, 2);
      expect(summary.achievements.any((a) => a.id == 'ach-1'), isTrue);

      // 4. Registra notas en el diario
      await repository.updateJournalEntriesCount(3, userId);
      summary = await repository.getProgressSummary(userId);
      expect(summary.metrics.journalEntriesCount, 3);
      expect(summary.achievements.length, 3);
      expect(summary.achievements.any((a) => a.id == 'ach-3'), isTrue);
    });

    test('Usuarios existentes conservan sus avances previos intactos', () async {
      final existingState = LocalProgressDataSource.mockInitialState;
      final dataSource = LocalProgressDataSource(
        initialState: existingState,
        defaultUserId: 'existing_veteran_student',
      );
      final repository = LocalProgressRepositoryImpl(dataSource: dataSource);

      final summary = await repository.getProgressSummary('existing_veteran_student');
      expect(summary.streak.daysCount, 7);
      expect(summary.metrics.pomodoroSessions, 12);
      expect(summary.metrics.breathingMinutes, 145);
      expect(summary.achievements.length, 4);
      expect(summary.bloomedCount, 3);
      expect(summary.intentions.length, 3);
    });
  });
}
