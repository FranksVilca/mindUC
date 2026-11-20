import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/models/user_model.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/relaxation/data/repositories/relaxation_repository_impl.dart';
import 'package:minduc/features/relaxation/presentation/controllers/relaxation_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AuthRepositoryImpl authRepo;
  late RelaxationRepositoryImpl repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    authRepo = AuthRepositoryImpl(
      fakeDataSource: FakeAuthDataSource(
        const UserModel(
          uid: 'user_estudiante_1',
          email: 'estudiante@uc.cl',
          displayName: 'Estudiante UC',
          emailVerified: true,
          createdAtMillis: 1700000000000,
        ),
      ),
    );
    repo = RelaxationRepositoryImpl();
  });

  group('RelaxationController & Entity Unit Tests', () {
    test('initial state loads all 4 official activities with zero completed', () async {
      final notifier = RelaxationNotifier(
        repository: repo,
        authRepository: authRepo,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(notifier.state.activities.length, equals(4));
      expect(notifier.state.completedActivitiesCountToday, equals(0));
      expect(notifier.state.totalReliefMinutesToday, equals(0));
      expect(notifier.state.isPlaying, isFalse);
      expect(notifier.state.activeActivity, isNull);

      final activityIds = notifier.state.activities.map((a) => a.id).toList();
      expect(activityIds, containsAll([
        'neck_stretch',
        'back_stretch',
        'jaw_massage',
        'smart_visual_break',
      ]));
    });

    test('startActivity sets active activity, step 0, and begins timer', () async {
      final notifier = RelaxationNotifier(
        repository: repo,
        authRepository: authRepo,
      );

      notifier.startActivity('neck_stretch');

      expect(notifier.state.activeActivity, isNotNull);
      expect(notifier.state.activeActivity!.id, equals('neck_stretch'));
      expect(notifier.state.currentStepIndex, equals(0));
      expect(notifier.state.currentStep!.title, equals('Inclinación lateral derecha'));
      expect(notifier.state.stepRemainingSeconds, equals(25));
      expect(notifier.state.isPlaying, isTrue);
      expect(notifier.state.isSessionCompleted, isFalse);
    });

    test('togglePlayPause pauses and resumes countdown', () {
      final notifier = RelaxationNotifier(
        repository: repo,
        authRepository: authRepo,
      );

      notifier.startActivity('back_stretch');
      expect(notifier.state.isPlaying, isTrue);

      notifier.togglePlayPause();
      expect(notifier.state.isPlaying, isFalse);

      notifier.togglePlayPause();
      expect(notifier.state.isPlaying, isTrue);
    });

    test('nextStep and previousStep navigate through all 5 steps', () {
      final notifier = RelaxationNotifier(
        repository: repo,
        authRepository: authRepo,
      );

      notifier.startActivity('neck_stretch');
      expect(notifier.state.currentStepIndex, equals(0));

      // Avanzar al paso 2
      notifier.nextStep();
      expect(notifier.state.currentStepIndex, equals(1));
      expect(notifier.state.currentStep!.title, equals('Sostén consciente'));

      // Avanzar al paso 3
      notifier.nextStep();
      expect(notifier.state.currentStepIndex, equals(2));
      expect(notifier.state.currentStep!.title, equals('Retorno al centro'));

      // Retroceder al paso 2
      notifier.previousStep();
      expect(notifier.state.currentStepIndex, equals(1));
      expect(notifier.state.currentStep!.title, equals('Sostén consciente'));
    });

    test('completing the 5th step marks routine completed and persists in repository', () async {
      final notifier = RelaxationNotifier(
        repository: repo,
        authRepository: authRepo,
      );

      notifier.startActivity('neck_stretch');

      // Avanzar hasta el último paso (paso 4, índice 4)
      notifier.nextStep(); // paso 1 -> 2
      notifier.nextStep(); // paso 2 -> 3
      notifier.nextStep(); // paso 3 -> 4
      notifier.nextStep(); // paso 4 -> 5

      expect(notifier.state.currentStepIndex, equals(4));
      expect(notifier.state.isSessionCompleted, isFalse);

      // Siguiente en el último paso culmina la rutina
      notifier.nextStep();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(notifier.state.isSessionCompleted, isTrue);
      expect(notifier.state.isPlaying, isFalse);

      final completedNeck = notifier.state.activities.firstWhere((a) => a.id == 'neck_stretch');
      expect(completedNeck.isCompletedToday, isTrue);
      expect(completedNeck.completionsCount, equals(1));
      expect(notifier.state.completedActivitiesCountToday, equals(1));
      expect(notifier.state.totalReliefMinutesToday, equals(2));
    });

    test('User isolation: completions by User A do not affect User B', () async {
      final notifierUserA = RelaxationNotifier(
        repository: repo,
        authRepository: authRepo,
      );

      notifierUserA.startActivity('jaw_massage');
      for (int i = 0; i < 5; i++) {
        notifierUserA.nextStep();
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(notifierUserA.state.completedActivitiesCountToday, equals(1));

      // Crear sesión para Usuario B
      final authRepoB = AuthRepositoryImpl(
        fakeDataSource: FakeAuthDataSource(
          const UserModel(
            uid: 'user_nuevo_2',
            email: 'nuevo@uc.cl',
            displayName: 'Nuevo Estudiante',
            emailVerified: true,
            createdAtMillis: 1700000000000,
          ),
        ),
      );

      final notifierUserB = RelaxationNotifier(
        repository: repo,
        authRepository: authRepoB,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Usuario B inicia completamente limpio
      expect(notifierUserB.state.completedActivitiesCountToday, equals(0));
      expect(notifierUserB.state.totalReliefMinutesToday, equals(0));
    });

    test('all 20 steps across all 4 activities have valid steps, ergonomic tips and durations', () async {
      final activities = await repo.getActivities(userId: 'test_user');
      expect(activities.length, equals(4));

      for (final activity in activities) {
        expect(activity.steps.length, equals(5));
        for (final step in activity.steps) {
          expect(step.title.isNotEmpty, isTrue);
          expect(step.instruction.isNotEmpty, isTrue);
          expect(step.ergonomicTip.isNotEmpty, isTrue);
          expect(step.durationSeconds, greaterThan(0));
          expect(step.bodyPartFocus.isNotEmpty, isTrue);
        }
      }
    });
  });
}
