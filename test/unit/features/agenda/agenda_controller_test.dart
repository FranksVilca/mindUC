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
    LocalAgendaDataSource.clearActivities();
    dataSource = LocalAgendaDataSource(
      initialActivities: LocalAgendaDataSource.mockInitialActivities,
    );
    repository = LocalAgendaRepositoryImpl(dataSource: dataSource);
    notifier = AgendaNotifier(
      repository: repository,
      initialDate: DateTime(2024, 10, 24),
    );
  });

  tearDown(() {
    LocalAgendaDataSource.clearActivities();
  });

  group('AgendaNotifier Unit Tests', () {
    test('initial state loads Figma mock activities for 2024-10-24', () async {
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

    test('new user begins with completely empty agenda and zero activities', () async {
      final emptyDataSource = LocalAgendaDataSource();
      final emptyRepo = LocalAgendaRepositoryImpl(dataSource: emptyDataSource);
      final emptyNotifier = AgendaNotifier(
        repository: emptyRepo,
        userId: 'brand_new_user_123',
      );
      await Future<void>.delayed(Duration.zero);
      expect(emptyNotifier.state.allActivities, isEmpty);
      expect(emptyNotifier.state.totalForDay, 0);
      expect(emptyNotifier.state.completedForDay, 0);
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

    test('toggleActivityCompletion toggles completion and updates rhythm balance', () async {
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.completedForDay, 2);

      // Desmarcar actividad 1 (inicialmente completada)
      await notifier.toggleActivityCompletion('activity-1');
      expect(notifier.state.completedForDay, 1);
      expect(notifier.state.rhythmText, '4 actividades · 1 completadas');

      // Marcar actividad 3 (inicialmente no completada)
      await notifier.toggleActivityCompletion('activity-3');
      expect(notifier.state.completedForDay, 2);

      // Volver a marcar actividad 1
      await notifier.toggleActivityCompletion('activity-1');
      expect(notifier.state.completedForDay, 3);
    });

    test('createActivity adds a new activity and updates list', () async {
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.allActivities.length, 4);

      await notifier.createActivity(
        title: 'Estiramiento suave de espalda',
        subtitle: '5 min para aflojar tensiones post estudio.',
        scheduledDateTime: DateTime(2024, 10, 24, 18, 0),
        category: AgendaCategory.saludMental,
      );

      expect(notifier.state.allActivities.length, 5);
      expect(
        notifier.state.allActivities.any(
          (a) => a.title == 'Estiramiento suave de espalda',
        ),
        isTrue,
      );
      expect(notifier.state.totalForDay, 5);
    });

    test('selectDate updates selectedDate and returns activities for that day', () async {
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.totalForDay, 4);

      // Cambiar al día siguiente (25 de octubre) donde no hay actividades
      notifier.selectDate(DateTime(2024, 10, 25));
      expect(notifier.state.selectedDate, DateTime(2024, 10, 25));
      expect(notifier.state.totalForDay, 0);
      expect(notifier.state.filteredActivities, isEmpty);

      // Volver al 24
      notifier.selectDate(DateTime(2024, 10, 24));
      expect(notifier.state.totalForDay, 4);
    });

    test('updateActivity updates title, date, time and category of an existing activity', () async {
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.allActivities.length, 4);

      // Editar la actividad 1
      await notifier.updateActivity(
        id: 'activity-1',
        title: 'Meditación matutina avanzada',
        subtitle: '15 min de respiración 4-4-4',
        scheduledDateTime: DateTime(2024, 10, 24, 9, 30),
        category: AgendaCategory.saludMental,
      );

      final updated = notifier.state.allActivities.firstWhere((a) => a.id == 'activity-1');
      expect(updated.title, 'Meditación matutina avanzada');
      expect(updated.subtitle, '15 min de respiración 4-4-4');
      expect(updated.category, AgendaCategory.saludMental);
      expect(updated.scheduledDateTime.hour, 9);
      expect(updated.scheduledDateTime.minute, 30);
    });

    test('deleteActivity removes activity from list', () async {
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.allActivities.length, 4);

      await notifier.deleteActivity('activity-4');
      expect(notifier.state.allActivities.length, 3);
      expect(
        notifier.state.allActivities.any((a) => a.id == 'activity-4'),
        isFalse,
      );
    });

    test('createActivity and updateActivity support multiple reminder alarms', () async {
      await Future<void>.delayed(Duration.zero);

      await notifier.createActivity(
        title: 'Examen de Cálculo Integral',
        subtitle: 'Revisión final de fórmulas',
        scheduledDateTime: DateTime(2024, 10, 24, 10, 0),
        category: AgendaCategory.estudioTrabajo,
        reminderMinutesList: [1440, 120, 15, 0],
      );

      final created = notifier.state.allActivities
          .firstWhere((a) => a.title == 'Examen de Cálculo Integral');
      expect(created.reminderMinutesList, [1440, 120, 15, 0]);
      expect(created.reminderMinutesBefore, 1440);

      await notifier.updateActivity(
        id: created.id,
        title: 'Examen de Cálculo Integral - Reprogramado',
        subtitle: 'Aula Magna',
        scheduledDateTime: DateTime(2024, 10, 24, 11, 0),
        category: AgendaCategory.estudioTrabajo,
        reminderMinutesList: [30, 5],
      );

      final updated = notifier.state.allActivities
          .firstWhere((a) => a.id == created.id);
      expect(updated.title, 'Examen de Cálculo Integral - Reprogramado');
      expect(updated.reminderMinutesList, [30, 5]);
      expect(updated.reminderMinutesBefore, 30);
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
            title: 'A1',
            subtitle: 'S1',
            scheduledDateTime: date,
            category: AgendaCategory.autocuidado,
            isCompleted: true,
            createdAt: date,
          ),
          AgendaActivity(
            id: '2',
            title: 'A2',
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
