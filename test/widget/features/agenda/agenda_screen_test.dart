import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/agenda/presentation/screens/agenda_screen.dart';

void main() {
  group('AgendaScreen Integration Widget Tests', () {
    testWidgets('renders all agenda screen components according to Figma design',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AgendaScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Cabecera
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Agenda'), findsOneWidget);

      // Título y contexto de fecha
      expect(find.textContaining('Mi Agenda'), findsOneWidget);
      expect(find.text('Jueves, Octubre 2024'), findsOneWidget);
      expect(find.text('Semana 43'), findsOneWidget);

      // Tira semanal (días 21 al 27)
      expect(find.text('Lun'), findsOneWidget);
      expect(find.text('Jue'), findsOneWidget);
      expect(find.text('Dom'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);

      // Tarjeta de balance
      expect(find.text('Ritmo en equilibrio'), findsOneWidget);
      expect(find.text('4 actividades · 2 completadas'), findsOneWidget);
      expect(find.text('Historial'), findsOneWidget);

      // Chips de filtrado
      expect(find.text('Todas'), findsOneWidget);
      expect(find.text('Autocuidado'), findsWidgets);
      expect(find.text('Estudio / Trabajo'), findsOneWidget);

      // 4 actividades de Figma
      expect(
        find.text('Meditación matutina y respiración'),
        findsOneWidget,
      );
      expect(
        find.text('Sesión de estudio concentrado (Pomodoro)'),
        findsOneWidget,
      );
      expect(
        find.text('Caminata al aire libre sin pantallas'),
        findsOneWidget,
      );
      expect(
        find.text('Escribir en mi Diario Personal de gratitud'),
        findsOneWidget,
      );

      // Botones flotantes
      expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
      expect(find.text('Nueva'), findsOneWidget);
    });

    testWidgets('filters activities when category chip is selected',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AgendaScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Filtrar por Autocuidado
      await tester.tap(find.widgetWithText(InkWell, 'Autocuidado').first);
      await tester.pumpAndSettle();

      expect(find.text('Meditación matutina y respiración'), findsOneWidget);
      expect(
        find.text('Escribir en mi Diario Personal de gratitud'),
        findsOneWidget,
      );
      expect(
        find.text('Sesión de estudio concentrado (Pomodoro)'),
        findsNothing,
      );

      // Filtrar por Estudio / Trabajo
      await tester.tap(find.text('Estudio / Trabajo'));
      await tester.pumpAndSettle();

      expect(
        find.text('Sesión de estudio concentrado (Pomodoro)'),
        findsOneWidget,
      );
      expect(find.text('Meditación matutina y respiración'), findsNothing);

      // Volver a Todas
      await tester.tap(find.text('Todas'));
      await tester.pumpAndSettle();

      expect(find.text('Meditación matutina y respiración'), findsOneWidget);
      expect(
        find.text('Sesión de estudio concentrado (Pomodoro)'),
        findsOneWidget,
      );
    });

    testWidgets('toggles activity completion and updates balance card',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AgendaScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('4 actividades · 2 completadas'), findsOneWidget);

      // Tocar el check de la primera actividad ("Meditación matutina y respiración", inicialmente completada)
      final firstCheck = find.byIcon(Icons.check_rounded).first;
      await tester.tap(firstCheck);
      await tester.pumpAndSettle();

      // Debe conmutar a 1 completada
      expect(find.text('4 actividades · 1 completadas'), findsOneWidget);

      // Volver a conmutar
      await tester.tap(find.text('Meditación matutina y respiración'));
      await tester.pumpAndSettle();

      // Debe retornar a 2 completadas
      expect(find.text('4 actividades · 2 completadas'), findsOneWidget);
    });

    testWidgets('creates a new activity via modal and inserts into list',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AgendaScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('4 actividades · 2 completadas'), findsOneWidget);

      // Pulsar botón flotante 'Nueva'
      await tester.tap(find.text('Nueva'));
      await tester.pumpAndSettle();

      expect(find.text('Nueva actividad consciente'), findsOneWidget);

      // Escribir título
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(
        textFields.first,
        'Pausa de estiramiento consciente',
      );
      await tester.enterText(
        textFields.last,
        'Mover el cuello y hombros suavemente.',
      );

      // Guardar
      await tester.tap(find.text('Guardar actividad'));
      await tester.pumpAndSettle();

      // Modal cerrado y actividad visible
      expect(find.text('Nueva actividad consciente'), findsNothing);
      expect(find.text('5 actividades · 2 completadas'), findsOneWidget);
      expect(find.text('Pausa de estiramiento consciente'), findsOneWidget);
    });

    testWidgets('switches day on weekly strip and displays empty state',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AgendaScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Pulsar en el día 25 (Viernes)
      await tester.tap(find.text('25'));
      await tester.pumpAndSettle();

      // Día 25 no tiene actividades precargadas
      expect(find.text('0 actividades · 0 completadas'), findsOneWidget);
      expect(
        find.textContaining('Día despejado para descansar o fluir'),
        findsOneWidget,
      );
    });

    testWidgets('tapping microphone button shows gentle voice assistance notice',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AgendaScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Pulsar icono de micrófono
      await tester.tap(find.byIcon(Icons.mic_none_rounded));
      await tester.pump();

      expect(
        find.text('Agendador consciente por voz en preparación 🌿'),
        findsOneWidget,
      );
    });
  });
}
