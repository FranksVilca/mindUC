import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/progress_gamification/domain/entities/organic_achievement.dart';
import 'package:minduc/features/progress_gamification/presentation/widgets/achievements_garden.dart';

void main() {
  group('AchievementsGarden Widget Tests', () {
    testWidgets('renders garden header, bloomed badge and 4 achievement cards',
        (tester) async {
      const achievements = [
        OrganicAchievement(
          id: 'ach-1',
          title: 'Semilla de Paz',
          description: '1ª semana seguida de respiración guiada',
          category: AchievementCategory.peace,
          isBloomed: true,
          currentProgress: 7.0,
          maxProgress: 7.0,
          progressLabel: 'Florecida',
        ),
        OrganicAchievement(
          id: 'ach-2',
          title: 'Mente Serena',
          description: '10 pausas activas completadas',
          category: AchievementCategory.mind,
          isBloomed: true,
          currentProgress: 10.0,
          maxProgress: 10.0,
          progressLabel: 'Florecida',
        ),
        OrganicAchievement(
          id: 'ach-3',
          title: 'Voz Auténtica',
          description: '5 notas reflexivas en tu diario',
          category: AchievementCategory.voice,
          isBloomed: true,
          currentProgress: 5.0,
          maxProgress: 5.0,
          progressLabel: 'Florecida',
        ),
        OrganicAchievement(
          id: 'ach-4',
          title: 'Foco Lúcido',
          description: '5h en modo concentración plena',
          category: AchievementCategory.focus,
          isBloomed: false,
          currentProgress: 4.0,
          maxProgress: 5.0,
          progressLabel: '4h de 5h (80%)',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AchievementsGarden(
                achievements: achievements,
                bloomedCount: 3,
                totalCount: 4,
              ),
            ),
          ),
        ),
      );

      // Encabezado
      expect(find.text('Jardín de logros'), findsOneWidget);
      expect(find.text('3 de 4'), findsOneWidget);
      expect(find.text('Reconocimientos orgánicos a tu constancia'), findsOneWidget);

      // Logros
      expect(find.text('Semilla de Paz'), findsOneWidget);
      expect(find.text('1ª semana seguida de respiración guiada'), findsOneWidget);

      expect(find.text('Mente Serena'), findsOneWidget);
      expect(find.text('10 pausas activas completadas'), findsOneWidget);

      expect(find.text('Voz Auténtica'), findsOneWidget);
      expect(find.text('5 notas reflexivas en tu diario'), findsOneWidget);

      expect(find.text('Foco Lúcido'), findsOneWidget);
      expect(find.text('5h en modo concentración plena'), findsOneWidget);
      expect(find.text('4h de 5h (80%)'), findsOneWidget);

      // 3 logros tienen pastilla "Florecida"
      expect(find.text('✓ Florecida'), findsNWidgets(3));
    });
  });
}

