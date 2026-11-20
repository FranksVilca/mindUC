import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/personal_journal/data/datasources/local_journal_datasource.dart';
import 'package:minduc/features/personal_journal/data/repositories/local_journal_repository_impl.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_entry.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_mood_pulse.dart';
import 'package:minduc/features/personal_journal/presentation/controllers/journal_controller.dart';

void main() {
  group('JournalNotifier Unit Tests', () {
    late LocalJournalDataSource dataSource;
    late LocalJournalRepositoryImpl repository;
    late JournalNotifier controller;

    setUp(() {
      LocalJournalDataSource.clearEntries();
      dataSource = LocalJournalDataSource(
        initialEntries: LocalJournalDataSource.mockInitialEntries,
      );
      repository = LocalJournalRepositoryImpl(dataSource: dataSource);
      controller = JournalNotifier(repository: repository);
    });

    tearDown(() {
      controller.dispose();
      LocalJournalDataSource.clearEntries();
    });

    test('Initial state loads the 3 mockup entries and sets default mood to enCalma',
        () async {
      await controller.loadEntries();
      final state = controller.state;

      expect(state.entryCount, 3);
      expect(state.hasEntries, isTrue);
      expect(state.selectedMoodPulse, JournalMoodPulse.enCalma);
      expect(state.entries.first.title,
          'Aprender a soltar lo que no puedo controlar');
      expect(state.entries.first.moodPulse, JournalMoodPulse.enCalma);
    });

    test('new user begins with completely empty journal and zero entries', () async {
      final emptyDataSource = LocalJournalDataSource();
      final emptyRepo = LocalJournalRepositoryImpl(dataSource: emptyDataSource);
      final emptyController = JournalNotifier(
        repository: emptyRepo,
        userId: 'brand_new_user_456',
      );
      await emptyController.loadEntries();
      expect(emptyController.state.entryCount, 0);
      expect(emptyController.state.hasEntries, isFalse);
      expect(emptyController.state.entries, isEmpty);
    });

    test('selectMoodPulse updates active mood in state', () {
      controller.selectMoodPulse(JournalMoodPulse.agradecida);
      expect(controller.state.selectedMoodPulse, JournalMoodPulse.agradecida);

      controller.selectMoodPulse(JournalMoodPulse.abrumada);
      expect(controller.state.selectedMoodPulse, JournalMoodPulse.abrumada);
    });

    test('createEntry persists a new reflection at the top of the timeline',
        () async {
      await controller.loadEntries();
      expect(controller.state.entryCount, 3);

      await controller.createEntry(
        title: 'Nueva reflexión nocturna',
        content: 'Hoy logré comprender un teorema complejo y me felicité por la perseverancia.',
        moodPulse: JournalMoodPulse.agradecida,
      );

      final state = controller.state;
      expect(state.entryCount, 4);
      expect(state.entries.first.title, 'Nueva reflexión nocturna');
      expect(state.entries.first.moodPulse, JournalMoodPulse.agradecida);
      expect(state.entries.first.readingTimeMinutes, 1);
    });

    test('updateEntry modifies existing reflection fields correctly', () async {
      await controller.loadEntries();
      final target = controller.state.entries.first;

      await controller.updateEntry(
        id: target.id,
        title: 'Título actualizado con serenidad',
        content: 'Nuevo contenido reflexivo ampliado con más detalles de autocuidado.',
        moodPulse: JournalMoodPulse.reflexiva,
      );

      final updated = controller.state.entries.firstWhere((e) => e.id == target.id);
      expect(updated.title, 'Título actualizado con serenidad');
      expect(updated.moodPulse, JournalMoodPulse.reflexiva);
    });

    test('deleteEntry removes the reflection from the local storage', () async {
      await controller.loadEntries();
      expect(controller.state.entryCount, 3);

      final targetId = controller.state.entries.first.id;
      await controller.deleteEntry(targetId);

      expect(controller.state.entryCount, 2);
      expect(controller.state.entries.any((e) => e.id == targetId), isFalse);
    });
  });

  group('JournalEntry Domain Calculations', () {
    test('readingTimeMinutes calculates correct duration based on word count', () {
      final shortEntry = JournalEntry(
        id: '1',
        title: 'Corto',
        content: 'Unas pocas palabras de gratitud.',
        moodPulse: JournalMoodPulse.enCalma,
        createdAt: DateTime.now(),
      );
      expect(shortEntry.readingTimeMinutes, 1);
      expect(shortEntry.readingTimeString, '1 min de lectura');

      final longContent = List.filled(400, 'reflexión').join(' ');
      final longEntry = JournalEntry(
        id: '2',
        title: 'Largo',
        content: longContent,
        moodPulse: JournalMoodPulse.reflexiva,
        createdAt: DateTime.now(),
      );
      expect(longEntry.readingTimeMinutes, 3);
      expect(longEntry.readingTimeString, '3 min de lectura');
    });

    test('previewSnippet truncates long text cleanly', () {
      const longText =
          'Esta es una frase muy larga para comprobar que el extracto del texto en la tarjeta resumen '
          'no supere los 130 caracteres y termine con puntos suspensivos elegantes para no romper la armonía visual.';
      final entry = JournalEntry(
        id: '1',
        title: 'Test Snippet',
        content: longText,
        moodPulse: JournalMoodPulse.enCalma,
        createdAt: DateTime.now(),
      );

      expect(entry.previewSnippet.length, lessThanOrEqualTo(130));
      expect(entry.previewSnippet.endsWith('...'), isTrue);
    });
  });
}
