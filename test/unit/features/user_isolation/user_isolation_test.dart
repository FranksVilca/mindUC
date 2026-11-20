import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/agenda/data/datasources/local_agenda_datasource.dart';
import 'package:minduc/features/agenda/data/repositories/local_agenda_repository_impl.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_activity.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_category.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/pomodoro_interval_type.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/pomodoro_state.dart';
import 'package:minduc/features/personal_journal/data/datasources/local_journal_datasource.dart';
import 'package:minduc/features/personal_journal/data/repositories/local_journal_repository_impl.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_entry.dart';
import 'package:minduc/features/personal_journal/domain/entities/journal_mood_pulse.dart';
import 'package:minduc/features/profile/data/datasources/local_profile_datasource.dart';
import 'package:minduc/features/profile/data/repositories/local_profile_repository_impl.dart';
import 'package:minduc/features/progress_gamification/data/datasources/local_progress_datasource.dart';
import 'package:minduc/features/progress_gamification/data/repositories/local_progress_repository_impl.dart';

void main() {
  setUp(() {
    FakeAuthDataSource.clearAccounts();
    LocalProfileDataSource.clearProfiles();
    LocalAgendaDataSource.clearActivities();
    LocalJournalDataSource.clearEntries();
    LocalProgressDataSource.clearStates();
  });

  tearDown(() {
    FakeAuthDataSource.clearAccounts();
    LocalProfileDataSource.clearProfiles();
    LocalAgendaDataSource.clearActivities();
    LocalJournalDataSource.clearEntries();
    LocalProgressDataSource.clearStates();
  });

  group('User Isolation & Data Segregation Verification', () {
    test('Temporizador Pomodoro: comienza consistentemente en 25:00 minutos', () {
      const defaultState = PomodoroState();
      expect(defaultState.remainingSeconds, 1500,
          reason: 'El temporizador de concentración debe iniciar en 1500s (25:00)');
      expect(defaultState.totalSeconds, 1500);
      expect(defaultState.intervalType, PomodoroIntervalType.focus);
      expect(defaultState.currentCycle, 1);
      expect(defaultState.totalCycles, 4);
      expect(defaultState.currentObjective, 'Enfoque consciente');
    });

    test('Aislamiento total y persistencia entre Usuario A y Usuario B', () async {
      final authDataSource = FakeAuthDataSource();
      final authRepo = AuthRepositoryImpl(fakeDataSource: authDataSource);

      final profileDataSource = LocalProfileDataSource();
      final profileRepo = LocalProfileRepositoryImpl(dataSource: profileDataSource);

      final agendaDataSource = LocalAgendaDataSource();
      final agendaRepo = LocalAgendaRepositoryImpl(dataSource: agendaDataSource);

      final journalDataSource = LocalJournalDataSource();
      final journalRepo = LocalJournalRepositoryImpl(dataSource: journalDataSource);

      final progressDataSource = LocalProgressDataSource();
      final progressRepo = LocalProgressRepositoryImpl(dataSource: progressDataSource);

      // -------------------------------------------------------------
      // 1. USUARIO A: REGISTRO Y CONFIGURACIÓN INICIAL
      // -------------------------------------------------------------
      final registerResultA = await authRepo.signUpWithEmailAndPassword(
        email: 'usuario.a@uc.cl',
        password: 'passwordA123',
        displayName: 'Usuario Alfa',
        department: 'Ingeniería',
      );
      expect(registerResultA.isSuccess, isTrue);
      final userA = registerResultA.dataOrNull!;
      expect(userA.displayName, 'Usuario Alfa');
      expect(userA.email, 'usuario.a@uc.cl');
      expect(userA.department, 'Ingeniería');

      // Perfil de Usuario A generado dinámicamente
      final profileResultA = await profileRepo.getProfileState(
        userId: userA.id,
        email: userA.email,
        displayName: userA.displayName,
        department: userA.department,
      );
      expect(profileResultA.isSuccess, isTrue);
      final profileA = profileResultA.dataOrNull!;
      expect(profileA.user.fullName, 'Usuario Alfa');
      expect(profileA.user.career, 'Ingeniería');
      expect(profileA.user.universityEmail, 'usuario.a@uc.cl');

      // Agenda de Usuario A debe comenzar completamente vacía
      final initialAgendaA = await agendaRepo.getActivities(userA.id);
      expect(initialAgendaA, isEmpty,
          reason: 'Un usuario nuevo debe comenzar con una agenda vacía');

      // Diario de Usuario A debe comenzar completamente vacío
      final initialJournalA = await journalRepo.getEntries(userA.id);
      expect(initialJournalA, isEmpty,
          reason: 'Un usuario nuevo debe comenzar con un diario personal vacío');

      // Métricas de progreso/sesiones de Usuario A deben comenzar en 0
      final initialProgressA = await progressRepo.getProgressSummary(userA.id);
      expect(initialProgressA.metrics.pomodoroSessions, 0,
          reason: 'El contador de sesiones debe comenzar en 0 para cada nuevo usuario');
      expect(initialProgressA.streak.daysCount, 0);
      expect(initialProgressA.metrics.breathingMinutes, 0);

      // Usuario A crea 2 actividades en su agenda
      final act1 = AgendaActivity(
        id: 'act_a_1',
        userId: userA.id,
        title: 'Estudiar Cálculo III',
        subtitle: 'Capítulo 4 - Integrales múltiples',
        category: AgendaCategory.estudioTrabajo,
        scheduledDateTime: DateTime.now().add(const Duration(hours: 2)),
        createdAt: DateTime.now(),
        isCompleted: false,
      );
      final act2 = AgendaActivity(
        id: 'act_a_2',
        userId: userA.id,
        title: 'Taller de Mindfulness UC',
        subtitle: 'Sesión guiada en San Joaquín',
        category: AgendaCategory.saludMental,
        scheduledDateTime: DateTime.now().add(const Duration(hours: 5)),
        createdAt: DateTime.now(),
        isCompleted: false,
      );
      await agendaRepo.saveActivity(act1);
      await agendaRepo.saveActivity(act2);

      // Usuario A crea 1 entrada en su diario
      final entryA = JournalEntry(
        id: 'entry_a_1',
        userId: userA.id,
        title: 'Mi primer día en el campus',
        content: 'Hoy comencé el semestre con serenidad y claridad para seguir avanzando paso a paso.',
        moodPulse: JournalMoodPulse.enCalma,
        createdAt: DateTime.now(),
      );
      await journalRepo.saveEntry(entryA);

      // Usuario A registra 2 sesiones completadas en progreso
      await progressRepo.incrementPomodoroSession(userA.id);
      await progressRepo.incrementPomodoroSession(userA.id);

      // Verificación de datos de Usuario A antes de cambiar de usuario
      final agendaUpdatedA = await agendaRepo.getActivities(userA.id);
      expect(agendaUpdatedA.length, 2);

      final journalUpdatedA = await journalRepo.getEntries(userA.id);
      expect(journalUpdatedA.length, 1);
      expect(journalUpdatedA.first.title, 'Mi primer día en el campus');

      final progressUpdatedA = await progressRepo.getProgressSummary(userA.id);
      expect(progressUpdatedA.metrics.pomodoroSessions, 2);

      // -------------------------------------------------------------
      // 2. CIERRE DE SESIÓN DE USUARIO A E INGRESO DE USUARIO B
      // -------------------------------------------------------------
      await authRepo.signOut();
      expect(authRepo.currentUser, isNull);

      final registerResultB = await authRepo.signUpWithEmailAndPassword(
        email: 'usuario.b@uc.cl',
        password: 'passwordB456',
        displayName: 'Usuario Beta',
        department: 'Medicina',
      );
      expect(registerResultB.isSuccess, isTrue);
      final userB = registerResultB.dataOrNull!;
      expect(userB.displayName, 'Usuario Beta');
      expect(userB.email, 'usuario.b@uc.cl');
      expect(userB.department, 'Medicina');

      // Perfil de Usuario B generado dinámicamente y aislado
      final profileResultB = await profileRepo.getProfileState(
        userId: userB.id,
        email: userB.email,
        displayName: userB.displayName,
        department: userB.department,
      );
      expect(profileResultB.isSuccess, isTrue);
      final profileB = profileResultB.dataOrNull!;
      expect(profileB.user.fullName, 'Usuario Beta');
      expect(profileB.user.career, 'Medicina');
      expect(profileB.user.universityEmail, 'usuario.b@uc.cl');
      expect(profileB.user.fullName, isNot('Camila Soto'));
      expect(profileB.user.fullName, isNot('Usuario Alfa'));

      // Agenda de Usuario B DEBE ESTAR COMPLETAMENTE VACÍA
      final agendaB = await agendaRepo.getActivities(userB.id);
      expect(agendaB, isEmpty,
          reason: 'Usuario B no debe heredar actividades de Usuario A ni datos precargados');

      // Diario de Usuario B DEBE ESTAR COMPLETAMENTE VACÍO
      final journalB = await journalRepo.getEntries(userB.id);
      expect(journalB, isEmpty,
          reason: 'Usuario B no debe ver las entradas del diario de Usuario A');

      // Sesiones de Usuario B DEBEN COMENZAR EN 0
      final progressB = await progressRepo.getProgressSummary(userB.id);
      expect(progressB.metrics.pomodoroSessions, 0,
          reason: 'El contador de sesiones de Usuario B debe iniciar estrictamente en 0');

      // Usuario B agrega su propia actividad
      final actB = AgendaActivity(
        id: 'act_b_1',
        userId: userB.id,
        title: 'Rotación Clínica Medicina',
        subtitle: 'Hospital Clínico UC',
        category: AgendaCategory.estudioTrabajo,
        scheduledDateTime: DateTime.now().add(const Duration(hours: 1)),
        createdAt: DateTime.now(),
        isCompleted: false,
      );
      await agendaRepo.saveActivity(actB);

      // Verificamos que Usuario B ahora tiene exactamente 1 actividad
      final agendaBUpdated = await agendaRepo.getActivities(userB.id);
      expect(agendaBUpdated.length, 1);
      expect(agendaBUpdated.first.title, 'Rotación Clínica Medicina');

      // -------------------------------------------------------------
      // 3. RETORNO DE USUARIO A: PERSISTENCIA Y AISLAMIENTO BIDIRECCIONAL
      // -------------------------------------------------------------
      await authRepo.signOut();
      final loginResultA = await authRepo.signInWithEmailAndPassword(
        email: 'usuario.a@uc.cl',
        password: 'passwordA123',
      );
      expect(loginResultA.isSuccess, isTrue);
      final reloadedUserA = loginResultA.dataOrNull!;
      expect(reloadedUserA.id, userA.id);

      // La agenda de Usuario A conserva intactas sus 2 actividades
      final reloadedAgendaA = await agendaRepo.getActivities(userA.id);
      expect(reloadedAgendaA.length, 2);
      expect(reloadedAgendaA.map((a) => a.title).toList(),
          containsAll(['Estudiar Cálculo III', 'Taller de Mindfulness UC']));
      expect(reloadedAgendaA.any((a) => a.title == 'Rotación Clínica Medicina'), isFalse,
          reason: 'La actividad de Usuario B no debe aparecer en la agenda de Usuario A');

      // El diario de Usuario A conserva intacta su entrada
      final reloadedJournalA = await journalRepo.getEntries(userA.id);
      expect(reloadedJournalA.length, 1);
      expect(reloadedJournalA.first.title, 'Mi primer día en el campus');

      // El progreso de Usuario A conserva sus 2 sesiones completadas
      final reloadedProgressA = await progressRepo.getProgressSummary(userA.id);
      expect(reloadedProgressA.metrics.pomodoroSessions, 2);
    });
  });
}
