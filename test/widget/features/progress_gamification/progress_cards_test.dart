import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/progress_gamification/domain/entities/active_streak.dart';
import 'package:minduc/features/progress_gamification/domain/entities/weekly_pause_metrics.dart';
import 'package:minduc/features/progress_gamification/presentation/widgets/active_streak_card.dart';
import 'package:minduc/features/progress_gamification/presentation/widgets/growth_badge_title.dart';
import 'package:minduc/features/progress_gamification/presentation/widgets/progress_header.dart';
import 'package:minduc/features/progress_gamification/presentation/widgets/weekly_pause_grid.dart';

void main() {
  group('ProgressHeader Widget Tests', () {
    testWidgets('renders back button, titles and avatar', (tester) async {
      bool backTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ProgressHeader(
              onBack: () => backTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('MINDUC'), findsOneWidget);
      expect(find.text('Gamificación Detallada'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pump();

      expect(backTapped, isTrue);
    });
  });

  group('GrowthBadgeTitle Widget Tests', () {
    testWidgets('renders category pill, main title and compassionate subtitle',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GrowthBadgeTitle(),
          ),
        ),
      );

      expect(find.text('🌱 Crecimiento consciente'), findsOneWidget);
      expect(find.text('Mi Progreso & Florecimiento'), findsOneWidget);
      expect(
        find.text('Celebrando cada paso hacia tu bienestar, a tu propio ritmo.'),
        findsOneWidget,
      );
    });
  });

  group('ActiveStreakCard Widget Tests', () {
    testWidgets('renders active streak count, message and 7 weekdays strip',
        (tester) async {
      const streak = ActiveStreak(
        daysCount: 7,
        message: 'Tu brote de serenidad floreció hoy con tu pausa matutina.',
        completedDays: [true, true, true, true, true, true, true],
        currentDayIndex: 6,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ActiveStreakCard(streak: streak),
          ),
        ),
      );

      expect(find.text('RACHA DE AUTOCUIDADO ACTIVO'), findsOneWidget);
      expect(find.text('7 días'), findsOneWidget);
      expect(find.text('consecutivos'), findsOneWidget);
      expect(
        find.text('Tu brote de serenidad floreció hoy con tu pausa matutina.'),
        findsOneWidget,
      );

      // Franja semanal
      expect(find.text('L'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      expect(find.text('X'), findsOneWidget);
      expect(find.text('J'), findsOneWidget);
      expect(find.text('V'), findsOneWidget);
      expect(find.text('S'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });
  });

  group('WeeklyPauseGrid Widget Tests', () {
    testWidgets('renders all 4 pause metric cards and descriptions',
        (tester) async {
      const metrics = WeeklyPauseMetrics(
        breathingMinutes: 145,
        pomodoroSessions: 12,
        journalEntriesCount: 9,
        balancePercentage: 85,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeeklyPauseGrid(metrics: metrics),
          ),
        ),
      );

      expect(find.text('Momentos de pausa'), findsOneWidget);
      expect(find.text('Esta semana'), findsOneWidget);

      expect(find.text('145 min'), findsOneWidget);
      expect(find.text('Respiración consciente y calma interior'), findsOneWidget);

      expect(find.text('12 sesiones'), findsOneWidget);
      expect(find.text('Enfoque amable Pomodoro completado'), findsOneWidget);

      expect(find.text('9 reflexiones'), findsOneWidget);
      expect(find.text('Entradas sinceras en diario íntimo'), findsOneWidget);

      expect(find.text('85%'), findsOneWidget);
      expect(find.text('Equilibrio y descanso semanal'), findsOneWidget);
    });
  });
}

