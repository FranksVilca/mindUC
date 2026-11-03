import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/objective_edit_dialog.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/pomodoro_cycle_progress.dart';

void main() {
  group('PomodoroCycleProgress Widget Tests', () {
    testWidgets('renders session title, cycle badge and 4 segment capsules',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PomodoroCycleProgress(
              sessionTitle: 'Sesión de la tarde',
              currentCycle: 2,
              totalCycles: 4,
            ),
          ),
        ),
      );

      expect(find.text('Sesión de la tarde'), findsOneWidget);
      expect(find.text('Ciclo 2 de 4'), findsOneWidget);
      expect(find.byIcon(Icons.spa_rounded), findsOneWidget);
    });
  });

  group('ObjectiveEditDialog Widget Tests', () {
    testWidgets('shows initial objective and saves new value', (tester) async {
      String savedObjective = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ObjectiveEditDialog.show(
                    context,
                    initialObjective: 'Lectura Cap. 4',
                    onSave: (val) => savedObjective = val,
                  );
                },
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
      );

      // Abrir diálogo
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      expect(find.text('Objetivo de Estudio'), findsOneWidget);
      expect(find.text('Lectura Cap. 4'), findsOneWidget);

      // Escribir nuevo objetivo
      await tester.enterText(find.byType(TextField), 'Nuevo informe');
      await tester.pumpAndSettle();

      // Guardar
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(savedObjective, 'Nuevo informe');
      expect(find.text('Objetivo de Estudio'), findsNothing);
    });

    testWidgets('cancels without saving when Cancelar is tapped', (tester) async {
      String savedObjective = 'original';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ObjectiveEditDialog.show(
                    context,
                    initialObjective: 'original',
                    onSave: (val) => savedObjective = val,
                  );
                },
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'modificado');
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(savedObjective, 'original');
      expect(find.text('Objetivo de Estudio'), findsNothing);
    });
  });
}

