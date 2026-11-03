import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/wellness/domain/entities/wellness_tool_item.dart';
import 'package:minduc/features/wellness/presentation/widgets/ai_assistant_dialog.dart';
import 'package:minduc/features/wellness/presentation/widgets/wellness_tools_grid.dart';

void main() {
  group('WellnessToolsGrid & AiAssistantDialog Widget Tests', () {
    testWidgets('WellnessToolsGrid renders all 4 tools and triggers onToolTap', (tester) async {
      WellnessToolItem? tappedTool;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WellnessToolsGrid(
                tools: WellnessToolItem.defaultTools,
                onToolTap: (tool) => tappedTool = tool,
              ),
            ),
          ),
        ),
      );

      // Verify all 4 tool titles exist
      expect(find.text('Respiración'), findsOneWidget);
      expect(find.text('Diario personal'), findsOneWidget);
      expect(find.text('Asistente IA ✨'), findsOneWidget);
      expect(find.text('Concentración'), findsOneWidget);

      // Verify badges
      expect(find.text('3 min'), findsOneWidget);
      expect(find.text('Privado'), findsOneWidget);
      expect(find.text('24/7'), findsOneWidget);
      expect(find.text('25m'), findsOneWidget);

      // Tap on Respiración
      await tester.tap(find.text('Respiración'));
      await tester.pump();

      expect(tappedTool?.id, 'breathing');

      // Tap on Asistente IA after ensuring it is visible in scroll view
      await tester.ensureVisible(find.text('Asistente IA ✨'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Asistente IA ✨'));
      await tester.pump();

      expect(tappedTool?.id, 'ai_assistant');
    });

    testWidgets('AiAssistantComingSoonDialog renders ethical guidance and dismisses', (tester) async {
      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AiAssistantComingSoonDialog(
              onDismiss: () => dismissed = true,
            ),
          ),
        ),
      );

      expect(find.text('Acompañamiento en Preparación ✨'), findsOneWidget);
      expect(find.text('Comprendido'), findsOneWidget);

      await tester.tap(find.text('Comprendido'));
      await tester.pump();

      expect(dismissed, isTrue);
    });
  });
}
