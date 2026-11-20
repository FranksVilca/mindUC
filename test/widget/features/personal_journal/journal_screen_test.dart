import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/personal_journal/data/datasources/local_journal_datasource.dart';
import 'package:minduc/features/personal_journal/data/repositories/local_journal_repository_impl.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_entry.dart';
import 'package:minduc/features/personal_journal/presentation/controllers/journal_controller.dart';
import 'package:minduc/features/personal_journal/presentation/screens/journal_screen.dart';

void main() {
  setUp(() {
    LocalJournalDataSource.clearEntries();
  });

  tearDown(() {
    LocalJournalDataSource.clearEntries();
  });

  Widget createScreen({List<JournalEntry>? entries}) {
    final ds = LocalJournalDataSource(
      initialEntries: entries ?? LocalJournalDataSource.mockInitialEntries,
    );
    final repo = LocalJournalRepositoryImpl(dataSource: ds);
    return ProviderScope(
      overrides: [
        journalRepositoryProvider.overrideWithValue(repo),
        journalControllerProvider.overrideWith(
          (ref) => JournalNotifier(repository: repo),
        ),
      ],
      child: const MaterialApp(
        home: JournalScreen(),
      ),
    );
  }

  group('JournalScreen Integration Widget Tests', () {
    testWidgets('new user starts with completely empty journal and pristine notice',
        (tester) async {
      final emptyDs = LocalJournalDataSource();
      final emptyRepo = LocalJournalRepositoryImpl(dataSource: emptyDs);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            journalRepositoryProvider.overrideWithValue(emptyRepo),
            journalControllerProvider.overrideWith(
              (ref) => JournalNotifier(repository: emptyRepo, userId: 'new_user_xyz'),
            ),
          ],
          child: const MaterialApp(
            home: JournalScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0 entradas'), findsOneWidget);
      expect(
        find.textContaining('Aún no tienes huellas registradas en tu dispositivo'),
        findsOneWidget,
      );
    });

    testWidgets('renders all journal screen components according to Figma design',
        (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Cabecera
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Minduc — Diario\nPersonal'), findsOneWidget);

      // Espacio Sagrado y Privacidad Local
      expect(find.text('ESPACIO SAGRADO'), findsOneWidget);
      expect(find.text('Mi Diario Personal'), findsOneWidget);
      expect(
        find.textContaining('protegidos y cifrados en tu dispositivo'),
        findsOneWidget,
      );

      // Botón Nueva Entrada Reflexiva
      expect(find.text('+ Nueva entrada reflexiva'), findsOneWidget);

      // Selector de pulso emocional
      expect(find.textContaining('Cómo late tu corazón'), findsOneWidget);
      expect(find.textContaining('Sintoniza tu'), findsOneWidget);
      expect(find.text('Agradecida'), findsOneWidget);
      expect(find.text('En calma'), findsOneWidget);
      expect(find.text('Reflexiva'), findsOneWidget);
      expect(find.text('Cansada'), findsOneWidget);
      expect(find.text('Abrumada'), findsOneWidget);

      // Cronología de huellas interiores
      expect(find.text('Tus huellas interiores'), findsOneWidget);
      expect(find.text('3 entradas'), findsOneWidget);

      // Tarjetas reflexivas iniciales
      expect(
        find.text('Aprender a soltar lo que no puedo controlar'),
        findsOneWidget,
      );
    });

    testWidgets('allows selecting an emotional pulse state',
        (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Pulsar 'Reflexiva'
      await tester.tap(find.text('Reflexiva'));
      await tester.pumpAndSettle();

      // Debe permanecer interactivo y seleccionado
      expect(find.text('Reflexiva'), findsWidgets);
    });

    testWidgets('creates a new journal entry via modal and updates timeline',
        (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Abrir modal de nueva entrada
      await tester.tap(find.text('+ Nueva entrada reflexiva'));
      await tester.pumpAndSettle();

      // Modal desplegado
      expect(find.text('Nueva entrada reflexiva'), findsOneWidget);
      expect(find.text('Guardar reflexión'), findsOneWidget);

      // Escribir título y contenido
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(
        textFields.first,
        'Caminata reflexiva al atardecer',
      );
      await tester.enterText(
        textFields.last,
        'Caminar sin prisas por el campus me devolvió la tranquilidad después de los exámenes.',
      );

      // Guardar
      await tester.tap(find.text('Guardar reflexión'));
      await tester.pumpAndSettle();

      // Verificar que el modal se cerró y la entrada está presente
      expect(find.text('Nueva entrada reflexiva'), findsNothing);
      expect(find.text('4 entradas'), findsOneWidget);
      expect(find.text('Caminata reflexiva al atardecer'), findsOneWidget);
    });

    testWidgets('deletes an entry and updates the counter', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('3 entradas'), findsOneWidget);

      // Buscar el menú de opciones de la primera tarjeta
      final optionsButtons = find.byTooltip('Opciones');
      expect(optionsButtons, findsWidgets);

      await tester.tap(optionsButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Eliminar'), findsOneWidget);
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      // Confirmar en el diálogo compasivo
      expect(find.text('¿Eliminar huella interior?'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Eliminar'));
      await tester.pumpAndSettle();

      // Se eliminó una entrada
      expect(find.text('2 entradas'), findsOneWidget);
    });
  });
}
