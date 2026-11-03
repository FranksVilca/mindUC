import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_category.dart';
import 'package:minduc/features/agenda/presentation/widgets/activity_create_modal.dart';

void main() {
  group('ActivityCreateModal Widget Tests', () {
    testWidgets('captures input and calls onSave on confirm', (tester) async {
      String? savedTitle;
      String? savedSubtitle;
      AgendaCategory? savedCategory;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ActivityCreateModal.show(
                    context,
                    defaultDate: DateTime(2024, 10, 24),
                    onSave: (title, subtitle, scheduled, category) {
                      savedTitle = title;
                      savedSubtitle = subtitle;
                      savedCategory = category;
                    },
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      // Abrir modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Nueva actividad consciente'), findsOneWidget);
      expect(find.text('Guardar actividad'), findsOneWidget);

      // Ingresar título y descripción
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.first, 'Yoga matutino sereno');
      await tester.enterText(
        textFields.last,
        '15 min de estiramientos para soltar tensión muscular.',
      );

      // Cambiar categoría a 'Salud mental'
      await tester.tap(find.text('Salud mental'));
      await tester.pumpAndSettle();

      // Guardar
      await tester.tap(find.text('Guardar actividad'));
      await tester.pumpAndSettle();

      expect(savedTitle, 'Yoga matutino sereno');
      expect(
        savedSubtitle,
        '15 min de estiramientos para soltar tensión muscular.',
      );
      expect(savedCategory, AgendaCategory.saludMental);
    });

    testWidgets('shows snackbar when title is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ActivityCreateModal.show(
                    context,
                    defaultDate: DateTime(2024, 10, 24),
                    onSave: (_, __, ___, ____) {},
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Intentar guardar con campos vacíos
      await tester.tap(find.text('Guardar actividad'));
      await tester.pump();

      expect(
        find.text('Por favor escribe un título para tu actividad.'),
        findsOneWidget,
      );
    });
  });
}

