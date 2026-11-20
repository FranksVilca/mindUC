import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/domain/entities/user_entity.dart';
import 'package:minduc/features/profile/data/datasources/local_profile_datasource.dart';
import 'package:minduc/features/profile/data/repositories/local_profile_repository_impl.dart';
import 'package:minduc/features/profile/domain/entities/wellness_preferences.dart';
import 'package:minduc/features/profile/presentation/controllers/profile_controller.dart';

void main() {
  group('ProfileNotifier Unit Tests', () {
    late LocalProfileDataSource dataSource;
    late LocalProfileRepositoryImpl repository;
    late ProfileNotifier notifier;

    setUp(() {
      LocalProfileDataSource.clearProfiles();
      dataSource = LocalProfileDataSource();
      repository = LocalProfileRepositoryImpl(dataSource: dataSource);
      notifier = ProfileNotifier(repository: repository);
    });

    tearDown(() {
      LocalProfileDataSource.clearProfiles();
    });

    test('initial state loads generic student profile when unauthenticated', () async {
      final state = notifier.state;

      expect(state.user.fullName, equals('Estudiante UC'));
      expect(state.user.career, equals('Pregrado UC'));
      expect(state.user.universityEmail, equals('estudiante@uc.cl'));
      expect(state.user.isMindfulActive, isTrue);

      expect(state.preferences.defaultAmbientSound, equals('Lluvia suave en el bosque'));
      expect(state.preferences.favoriteBreathingTechnique, equals('Caja 4–4–4'));
      expect(state.preferences.consciousRemindersEnabled, isTrue);

      expect(state.supportContact.title, equals('Línea de Apoyo Psicológico'));
      expect(state.supportContact.extensionNumber, equals('*4000'));
    });

    test('dynamic profile is generated from authenticated UserEntity without hardcoded data', () async {
      final user = UserEntity(
        id: 'usr_ana_valenzuela',
        email: 'ana.valenzuela@uc.cl',
        displayName: 'Ana Valenzuela',
        department: 'Ingeniería Civil',
        isEmailVerified: true,
        isAnonymous: false,
        createdAt: DateTime(2024, 1, 1),
      );

      final notifierWithUser = ProfileNotifier(
        repository: repository,
        currentUser: user,
      );
      await notifierWithUser.loadProfile();

      final state = notifierWithUser.state;
      expect(state.user.fullName, equals('Ana Valenzuela'));
      expect(state.user.career, equals('Ingeniería Civil'));
      expect(state.user.universityEmail, equals('ana.valenzuela@uc.cl'));
      expect(state.user.id, equals('usr_ana_valenzuela'));
    });

    test('toggleConsciousReminders switches conscious reminder preference', () async {
      expect(notifier.state.preferences.consciousRemindersEnabled, isTrue);

      await notifier.toggleConsciousReminders(false);
      expect(notifier.state.preferences.consciousRemindersEnabled, isFalse);

      await notifier.toggleConsciousReminders(true);
      expect(notifier.state.preferences.consciousRemindersEnabled, isTrue);
    });

    test('selectAmbientSound updates default ambient sound', () async {
      expect(
        notifier.state.preferences.defaultAmbientSound,
        equals('Lluvia suave en el bosque'),
      );

      await notifier.selectAmbientSound('Bosque al atardecer');
      expect(
        notifier.state.preferences.defaultAmbientSound,
        equals('Bosque al atardecer'),
      );
    });

    test('selectBreathingTechnique updates favorite breathing technique', () async {
      expect(
        notifier.state.preferences.favoriteBreathingTechnique,
        equals('Caja 4–4–4'),
      );

      await notifier.selectBreathingTechnique('Respiración 4–7–8');
      expect(
        notifier.state.preferences.favoriteBreathingTechnique,
        equals('Respiración 4–7–8'),
      );
    });

    test('updatePreferences updates multiple wellness preferences', () async {
      const newPrefs = WellnessPreferences(
        defaultAmbientSound: 'Océano calmo',
        favoriteBreathingTechnique: 'Respiración Abdominal',
        consciousRemindersEnabled: false,
        reminderIntervalDescription: 'Pausas cada 3 horas',
      );

      await notifier.updatePreferences(newPrefs);

      expect(notifier.state.preferences.defaultAmbientSound, equals('Océano calmo'));
      expect(notifier.state.preferences.favoriteBreathingTechnique, equals('Respiración Abdominal'));
      expect(notifier.state.preferences.consciousRemindersEnabled, isFalse);
    });

    test('logout returns true and clears session gracefully', () async {
      final success = await notifier.logout();
      expect(success, isTrue);
      expect(notifier.state.isLoading, isFalse);
    });
  });
}
