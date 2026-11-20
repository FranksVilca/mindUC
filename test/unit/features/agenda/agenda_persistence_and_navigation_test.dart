import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/agenda/data/datasources/local_agenda_datasource.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_activity.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_category.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LocalAgendaDataSource.clearActivities();
  });

  group('Agenda Persistence & Isolation Tests', () {
    test('Activity serialization toMap/fromMap matches', () {
      final now = DateTime(2026, 11, 5, 14, 30);
      final activity = AgendaActivity(
        id: 'act-123',
        userId: 'user_a',
        title: 'Estudiar para el certamen',
        subtitle: 'Capítulos 3 y 4',
        scheduledDateTime: now,
        category: AgendaCategory.estudioTrabajo,
        isCompleted: false,
        createdAt: now,
      );

      final json = activity.toJson();
      final restored = AgendaActivity.fromJson(json);

      expect(restored.id, 'act-123');
      expect(restored.userId, 'user_a');
      expect(restored.title, 'Estudiar para el certamen');
      expect(restored.subtitle, 'Capítulos 3 y 4');
      expect(restored.category, AgendaCategory.estudioTrabajo);
      expect(restored.isCompleted, isFalse);
    });

    test('Persists activities in SharedPreferences across datasource instances for same user', () async {
      final ds1 = LocalAgendaDataSource();
      final now = DateTime(2026, 11, 5, 9, 0);

      final activity = AgendaActivity(
        id: 'act-persist-1',
        userId: 'user_ana',
        title: 'Meditación matutina',
        subtitle: '15 minutos de respiración',
        scheduledDateTime: now,
        category: AgendaCategory.autocuidado,
        createdAt: now,
      );

      await ds1.saveActivity(activity);

      // Limpiar memoria simulando reinicio de la app o cambio de sesión
      LocalAgendaDataSource.clearActivities();

      // Nueva instancia de datasource
      final ds2 = LocalAgendaDataSource();
      final loaded = await ds2.getActivities('user_ana');

      expect(loaded.length, 1);
      expect(loaded.first.id, 'act-persist-1');
      expect(loaded.first.title, 'Meditación matutina');
      expect(loaded.first.userId, 'user_ana');

      // Otro usuario debe estar completamente vacío
      final userBActivities = await ds2.getActivities('user_carlos');
      expect(userBActivities, isEmpty);
    });

    test('Updating an activity persists updated fields', () async {
      final ds = LocalAgendaDataSource();
      final date = DateTime(2026, 11, 5, 10, 0);

      final original = AgendaActivity(
        id: 'act-edit-1',
        userId: 'user_test',
        title: 'Título original',
        subtitle: 'Sub original',
        scheduledDateTime: date,
        category: AgendaCategory.autocuidado,
        createdAt: date,
      );
      await ds.saveActivity(original);

      final updated = original.copyWith(
        title: 'Título editado',
        subtitle: 'Descripción corregida',
        category: AgendaCategory.saludMental,
        isCompleted: true,
      );
      await ds.saveActivity(updated);

      final list = await ds.getActivities('user_test');
      expect(list.length, 1);
      expect(list.first.title, 'Título editado');
      expect(list.first.subtitle, 'Descripción corregida');
      expect(list.first.category, AgendaCategory.saludMental);
      expect(list.first.isCompleted, isTrue);
    });

    test('Deleting an activity removes it from persistence', () async {
      final ds = LocalAgendaDataSource();
      final date = DateTime(2026, 11, 5, 10, 0);

      final act = AgendaActivity(
        id: 'act-del-1',
        userId: 'user_test',
        title: 'A borrar',
        subtitle: '',
        scheduledDateTime: date,
        category: AgendaCategory.autocuidado,
        createdAt: date,
      );
      await ds.saveActivity(act);
      expect((await ds.getActivities('user_test')).length, 1);

      await ds.deleteActivity('act-del-1', 'user_test');
      expect((await ds.getActivities('user_test')), isEmpty);

      // Confirmar persistencia tras borrar
      LocalAgendaDataSource.clearActivities();
      final dsReloaded = LocalAgendaDataSource();
      expect(await dsReloaded.getActivities('user_test'), isEmpty);
    });
  });

  group('Agenda Date & Week Navigation State Tests', () {
    test('Week navigation calculates 7 days and switches weeks properly', () {
      final baseDate = DateTime(2026, 11, 5); // Jueves 5 de Noviembre
      final state = AgendaState(selectedDate: baseDate);

      expect(state.weekDays.length, 7);
      expect(state.weekDays.first.day, 2); // Lunes 2
      expect(state.weekDays.last.day, 8); // Domingo 8

      // Avanzar semana (+7 días)
      final nextWeek = state.copyWith(
        selectedDate: state.selectedDate.add(const Duration(days: 7)),
      );
      expect(nextWeek.selectedDate.day, 12);
      expect(nextWeek.weekDays.first.day, 9); // Lunes 9
      expect(nextWeek.weekDays.last.day, 15); // Domingo 15

      // Retroceder semana (-7 días)
      final prevWeek = state.copyWith(
        selectedDate: state.selectedDate.subtract(const Duration(days: 7)),
      );
      expect(prevWeek.selectedDate.day, 29); // 29 de Octubre
      expect(prevWeek.selectedDate.month, 10);
    });

    test('Arbitrary date selection filters activities exactly for that date', () {
      final d1 = DateTime(2026, 11, 5, 10, 0);
      final d2 = DateTime(2026, 12, 25, 9, 0);

      final act1 = AgendaActivity(
        id: 'act-nov',
        userId: 'u1',
        title: 'Actividad Noviembre',
        subtitle: '',
        scheduledDateTime: d1,
        category: AgendaCategory.autocuidado,
        createdAt: d1,
      );
      final act2 = AgendaActivity(
        id: 'act-dec',
        userId: 'u1',
        title: 'Actividad Navidad',
        subtitle: '',
        scheduledDateTime: d2,
        category: AgendaCategory.autocuidado,
        createdAt: d2,
      );

      final stateNov = AgendaState(
        selectedDate: DateTime(2026, 11, 5),
        allActivities: [act1, act2],
      );
      expect(stateNov.activitiesForSelectedDay.length, 1);
      expect(stateNov.activitiesForSelectedDay.first.title, 'Actividad Noviembre');

      // Cambiar a Navidad
      final stateDec = stateNov.copyWith(selectedDate: DateTime(2026, 12, 25));
      expect(stateDec.activitiesForSelectedDay.length, 1);
      expect(stateDec.activitiesForSelectedDay.first.title, 'Actividad Navidad');
    });
  });
}
