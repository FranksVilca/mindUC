import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_colors.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/home/domain/entities/quick_access_item.dart';
import 'package:minduc/features/home/presentation/widgets/quick_access_grid.dart';

void main() {
  group('QuickAccessGrid Widget Tests', () {
    testWidgets('renders all 4 cards and triggers onItemTapped', (tester) async {
      QuickAccessItem? tappedItem;

      final testItems = [
        const QuickAccessItem(
          id: 'relaxation',
          title: 'Relajación',
          subtitle: 'Respira y libera tensión (10 min)',
          icon: Icons.self_improvement_rounded,
          backgroundColor: MindColors.autocuidado,
          targetRoute: '/wellness',
        ),
        const QuickAccessItem(
          id: 'agenda',
          title: 'Agenda',
          subtitle: '4 actividades pendientes hoy',
          icon: Icons.calendar_month_rounded,
          backgroundColor: MindColors.productividad,
          targetRoute: '/agenda',
        ),
        const QuickAccessItem(
          id: 'community',
          title: 'Comunidad',
          subtitle: 'Conecta en el foro anónimo UC',
          icon: Icons.groups_rounded,
          backgroundColor: MindColors.saludMental,
          targetRoute: '/community',
        ),
        const QuickAccessItem(
          id: 'progress',
          title: 'Mi progreso',
          subtitle: 'Racha de 7 días continuos',
          icon: Icons.show_chart_rounded,
          backgroundColor: MindColors.accentCalm,
          targetRoute: '/progress',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuickAccessGrid(
                items: testItems,
                onItemTapped: (item) => tappedItem = item,
              ),
            ),
          ),
        ),
      );

      // Verify header texts
      expect(find.text('Espacios para ti'), findsOneWidget);
      expect(find.text('Explora tu bienestar'), findsOneWidget);

      // Verify titles and subtitles
      expect(find.text('Relajación'), findsOneWidget);
      expect(find.text('Respira y libera tensión (10 min)'), findsOneWidget);

      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('4 actividades pendientes hoy'), findsOneWidget);

      expect(find.text('Comunidad'), findsOneWidget);
      expect(find.text('Conecta en el foro anónimo UC'), findsOneWidget);

      expect(find.text('Mi progreso'), findsOneWidget);
      expect(find.text('Racha de 7 días continuos'), findsOneWidget);

      // Tap on Agenda
      await tester.tap(find.text('Agenda'));
      await tester.pumpAndSettle();

      expect(tappedItem?.id, equals('agenda'));
    });
  });
}

