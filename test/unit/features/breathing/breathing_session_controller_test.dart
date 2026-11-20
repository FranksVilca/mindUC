import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/models/user_model.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/breathing/data/datasources/fake_breathing_datasource.dart';
import 'package:minduc/features/breathing/data/repositories/breathing_repository_impl.dart';
import 'package:minduc/features/breathing/domain/entities/breathing_phase.dart';
import 'package:minduc/features/breathing/domain/entities/breathing_session_state.dart';
import 'package:minduc/features/breathing/domain/entities/breathing_technique.dart';
import 'package:minduc/features/breathing/domain/services/breathing_audio_service.dart';
import 'package:minduc/features/breathing/presentation/controllers/breathing_session_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BreathingSessionNotifier Unit Tests', () {
    late BreathingRepositoryImpl breathingRepo;
    late AuthRepositoryImpl authRepo;
    late FakeBreathingAudioService audioService;
    late BreathingSessionNotifier controller;

    setUp(() {
      breathingRepo = BreathingRepositoryImpl(fakeDataSource: FakeBreathingDataSource());
      final fakeAuthDataSource = FakeAuthDataSource(
        const UserModel(
          uid: 'test_user_uid',
          email: 'test@minduc.cl',
          displayName: 'Estudiante UC',
          emailVerified: true,
          createdAtMillis: 1792873200000,
        ),
      );
      authRepo = AuthRepositoryImpl(fakeDataSource: fakeAuthDataSource);
      audioService = FakeBreathingAudioService();
      controller = BreathingSessionNotifier(
        breathingRepository: breathingRepo,
        authRepository: authRepo,
        audioService: audioService,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state is configured with box444 and 600s target', () {
      final state = controller.state;
      expect(state.technique, BreathingTechnique.box444);
      expect(state.status, SessionStatus.idle);
      expect(state.currentCycle, 1);
      expect(state.targetTotalSeconds, 600);
      expect(state.phase, BreathingPhase.inhale);
      expect(state.phaseSecondsRemaining, 4);
      expect(state.totalCycles, 600 ~/ BreathingTechnique.box444.cycleDurationSeconds);
    });

    test('playOrPause toggles between running and paused', () {
      controller.playOrPause();
      expect(controller.state.status, SessionStatus.running);

      controller.playOrPause();
      expect(controller.state.status, SessionStatus.paused);

      controller.playOrPause();
      expect(controller.state.status, SessionStatus.running);
    });

    test('tick advances phase from inhale to hold, hold to exhale, and exhale to next cycle', () {
      controller.playOrPause(); // running

      // Inhale is 4 seconds. Let's tick 4 times.
      controller.tick(); // 3s
      expect(controller.state.phase, BreathingPhase.inhale);
      expect(controller.state.phaseSecondsRemaining, 3);
      expect(controller.state.totalSecondsElapsed, 1);

      controller.tick(); // 2s
      controller.tick(); // 1s
      controller.tick(); // 0s -> should transition to hold (4s)
      expect(controller.state.phase, BreathingPhase.hold);
      expect(controller.state.phaseSecondsRemaining, 4);

      // Hold is 4 seconds. Tick 4 times.
      controller.tick(); // 3s
      controller.tick(); // 2s
      controller.tick(); // 1s
      controller.tick(); // transition to exhale (4s)
      expect(controller.state.phase, BreathingPhase.exhale);
      expect(controller.state.phaseSecondsRemaining, 4);

      // Exhale is 4 seconds. Tick 4 times.
      controller.tick(); // 3s
      controller.tick(); // 2s
      controller.tick(); // 1s
      controller.tick(); // cycle completed -> next cycle inhale
      expect(controller.state.currentCycle, 2);
      expect(controller.state.phase, BreathingPhase.inhale);
      expect(controller.state.phaseSecondsRemaining, 4);
    });

    test('setTechnique to serene87 skips hold phase', () {
      controller.setTechnique(BreathingTechnique.serene87);
      expect(controller.state.technique, BreathingTechnique.serene87);
      expect(controller.state.phaseSecondsRemaining, 8);

      controller.playOrPause();

      // Tick 8 times through inhale
      for (int i = 0; i < 8; i++) {
        controller.tick();
      }

      // Should transition directly to exhale because holdSeconds == 0
      expect(controller.state.phase, BreathingPhase.exhale);
      expect(controller.state.phaseSecondsRemaining, 7);
    });

    test('setTargetDuration recalculates totalCycles and triggers completion when reached', () async {
      controller.setTargetDuration(3); // 3 seconds target
      expect(controller.state.targetTotalSeconds, 3);

      controller.playOrPause();
      controller.tick();
      controller.tick();
      controller.tick(); // Reached 3 seconds

      expect(controller.state.status, SessionStatus.completed);

      // Check repository saved the session
      await Future<void>.delayed(Duration.zero);
      final logs = await breathingRepo.getUserSessions('test_user_uid');
      expect(logs.isSuccess, isTrue);
      final list = logs.dataOrNull!;
      expect(list.length, 1);
      expect(list.first.durationSeconds, 3);
    });

    test('resetSession restores initial state', () {
      controller.playOrPause();
      controller.tick();
      controller.tick();

      controller.resetSession();

      expect(controller.state.status, SessionStatus.idle);
      expect(controller.state.currentCycle, 1);
      expect(controller.state.totalSecondsElapsed, 0);
      expect(controller.state.phase, BreathingPhase.inhale);
      expect(controller.state.phaseSecondsRemaining, controller.state.technique.inhaleSeconds);
    });

    test('stopSession marks completed and persists session', () async {
      controller.playOrPause();
      for (int i = 0; i < 15; i++) {
        controller.tick();
      }

      await controller.stopSession();

      expect(controller.state.status, SessionStatus.completed);
      final logs = await breathingRepo.getUserSessions('test_user_uid');
      expect(logs.isSuccess, isTrue);
      final list = logs.dataOrNull!;
      expect(list.first.durationSeconds, 15);
    });
    test('audioService plays guidance sound on play and on phase transition', () {
      expect(audioService.playedPhases, isEmpty);

      controller.playOrPause();
      expect(audioService.playedPhases, [BreathingPhase.inhale]);

      // Complete inhale (4 ticks)
      controller.tick();
      controller.tick();
      controller.tick();
      controller.tick();

      expect(audioService.playedPhases, [
        BreathingPhase.inhale,
        BreathingPhase.hold,
      ]);

      controller.toggleSound();
      expect(controller.state.isSoundEnabled, isFalse);
      expect(audioService.isSoundEnabled, isFalse);
    });
  });
}
