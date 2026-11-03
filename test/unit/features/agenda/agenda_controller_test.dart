import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/agenda/data/datasources/local_agenda_datasource.dart';
import 'package:minduc/features/agenda/data/repositories/local_agenda_repository_impl.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_activity.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_category.dart';
import 'package:minduc/features/agenda/domain/entities/day_schedule.dart';
import 'package:minduc/features/agenda/presentation/controllers/agenda_controller.dart';

void main() {
  late LocalAgendaDataSource dataSource;
  late LocalAgendaRepositoryImpl repository;
  late AgendaNotifier notifier;

  setUp(() {
    dataSource = LocalAgendaDataSource();
    repository = LocalAgendaRepositoryImpl(dataSource: dataSource);
    notifier = AgendaNotifier(
      repository: repository,
      initialDate: DateTime(2024, 10, 24),
    );
  });

  group('AgendaNotifier Unit Tests', () {
    test('initial state loads Figma mock activities for 2024-10-24', () async {
      // Allow initial load to complete
      await Future<void>.delayed(Duration.zero);

      final state = notifier.state;
      expect(state.selectedDate, DateTime(2024, 10, 24));
      expect(state.selectedFilter, 'Todas');
      expect(state.totalForDay, 4);
      expect(state.completedForDay, 2);
      expect(state.rhythmText, '4 actividades · 2 completadas');
      expect(state.filteredActivities.length, 4);
      expect(state.weekNumber, 43);
    });

    test('selectFilter filters activities by category', () async {
      await Future<void>.delayed(Duration.zero);

      // Filtrar por Autocuidado
      notifier.selectFilter('Autocuidado');
      expect(notifier.state.selectedFilter, 'Autocuidado');
      expect(notifier.state.filteredActivities.length, 2);
      expect(
        notifier.state.filteredActivities.every(
          (a) => a.category == AgendaCategory.autocuidado,
        ),
        isTrue,
      );

      // Filtrar por Estudio / Trabajo
      notifier.selectFilter('Estudio / Trabajo');
      expect(notifier.state.filteredActivities.length, 1);
      expect(
        notifier.state.filteredActivities.first.category,
        AgendaCategory.estudioTrabajo,
      );

      // Volver a Todas
      notifier.selectFilter('Todas');
      expect(notifier.state.filteredActivities.length, 4);
    });

    test('toggleActivityCompletion toggles completion and updates rhythm balance',
        () async {
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.completedForDay, 2);

      // Alternar activity-3 (Caminata al aire libre, inicialmente incompleta)
      await notifier.toggleActivityCompletion('activity-3');

      expect(notifier.state.completedForDay, 3);
      expect(notifier.state.rhythmText, '4 actividades · 3 completadas');
      final updated = notifier.state.activitiesForSelectedDay
          .firstWhere((a) => a.id == 'activity-3');
      expect(updated.isCompleted, isTrue);

      // Volver a alternar activity-3
      await notifier.toggleActivityCompletion('activity-3');
      expect(notifier.state.completedForDay, 2);
    });

    test('createActivity adds a new activity and updates list', () async {
      await Future<void>.delayed(Duration.zero);

      await notifier.createActivity(
        title: 'Té consciente de pausa',
        subtitle: '5 min de silencio reparador.',
        scheduledDateTime: DateTime(2024, 10, 24, 18, 0),
        category: AgendaCategory.autocuidado,
      );

      expect(notifier.state.totalForDay, 5);
      expect(notifier.state.completedForDay, 2);
      expect(
        notifier.state.activitiesForSelectedDay.any(
          (a) => a.title == 'Té consciente de pausa',
        ),
        isTrue,
      );
    });

    test('selectDate updates selectedDate and returns activities for that day',
        () async {
      await Future<void>.delayed(Duration.zero);

      // Seleccionar un día sin actividades (25 de Octubre)
      notifier.selectDate(DateTime(2024, 10, 25));

      expect(notifier.state.selectedDate, DateTime(2024, 10, 25));
      expect(notifier.state.totalForDay, 0);
      expect(notifier.state.filteredActivities.isEmpty, isTrue);
    });

    test('deleteActivity removes activity from list', () async {
      await Future<void>.delayed(Duration.zero);

      await notifier.deleteActivity('activity-1');

      expect(notifier.state.totalForDay, 3);
      expect(
        notifier.state.activitiesForSelectedDay.any((a) => a.id == 'activity-1'),
        isFalse,
      );
    });
  });

  group('DaySchedule and AgendaActivity Unit Tests', () {
    test('DaySchedule calculates balance progress and week number', () {
      final date = DateTime(2024, 10, 24);
      final schedule = DaySchedule(
        date: date,
        activities: [
          AgendaActivity(
            id: '1',
            title: 'T1',
            subtitle: 'S1',
            scheduledDateTime: date,
            category: AgendaCategory.autocuidado,
            isCompleted: true,
            createdAt: date,
          ),
          AgendaActivity(
            id: '2',
            title: 'T2',
            subtitle: 'S2',
            scheduledDateTime: date,
            category: AgendaCategory.estudioTrabajo,
            isCompleted: false,
            createdAt: date,
          ),
        ],
      );

      expect(schedule.totalActivities, 2);
      expect(schedule.completedActivities, 1);
      expect(schedule.balanceProgress, 0.5);
      expect(schedule.weekNumber, 43);
      expect(schedule.hasActivities, isTrue);
    });

    test('AgendaActivity formattedTime formats AM and PM accurately', () {
      final am = AgendaActivity(
        id: '1',
        title: 'T1',
        subtitle: 'S1',
        scheduledDateTime: DateTime(2024, 10, 24, 8, 30),
        category: AgendaCategory.autocuidado,
        createdAt: DateTime.now(),
      );
      expect(am.formattedTime, '08:30 AM');

      final pm = AgendaActivity(
        id: '2',
        title: 'T2',
        subtitle: 'S2',
        scheduledDateTime: DateTime(2024, 10, 24, 16, 5),
        category: AgendaCategory.saludMental,
        createdAt: DateTime.now(),
      );
      expect(pm.formattedTime, '16:05 PM');
    });
  });
}

