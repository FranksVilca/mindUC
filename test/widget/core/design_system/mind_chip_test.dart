import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/design_system/chips/mind_chip.dart';
import 'package:minduc/core/theme/mind_colors.dart';
import 'package:minduc/core/theme/mind_theme.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      theme: MindTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('MindChip Widget Tests', () {
    testWidgets('renders label and indicator dot', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const MindChip(
            label: 'Autocuidado',
            dotColor: MindColors.autocuidadoAccent,
          ),
        ),
      );

      expect(find.text('Autocuidado'), findsOneWidget);
    });

    testWidgets('triggers onSelected when tapped', (tester) async {
      bool selected = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          MindChip(
            label: 'Estudio / Trabajo',
            isSelected: false,
            onTap: () => selected = true,
          ),
        ),
      );

      await tester.tap(find.text('Estudio / Trabajo'));
      await tester.pumpAndSettle();

      expect(selected, isTrue);
    });
  });
}

