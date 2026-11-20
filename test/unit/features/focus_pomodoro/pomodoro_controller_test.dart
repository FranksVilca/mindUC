import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/pomodoro_interval_type.dart';
import 'package:minduc/features/focus_pomodoro/presentation/controllers/pomodoro_controller.dart';

void main() {
  group('PomodoroNotifier Unit Tests', () {
    late PomodoroNotifier controller;

    setUp(() {
      controller = PomodoroNotifier();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state reflects 25:00 focus start and clean session', () {
      final state = controller.state;
      expect(state.sessionTitle, 'Sesión de concentración');
      expect(state.currentCycle, 1);
      expect(state.totalCycles, 4);
      expect(state.intervalType, PomodoroIntervalType.focus);
      expect(state.remainingSeconds, 1500); // 25:00
      expect(state.totalSeconds, 1500); // 25:00
      expect(state.isRunning, isFalse);
      expect(state.formattedRemainingTime, '25:00');
      expect(state.formattedTotalTime, 'de 25:00 min');
      expect(state.currentObjective, 'Enfoque consciente');
      expect(state.selectedSoundscapeId, 'rain');
      expect(state.isSoundscapePlaying, isFalse);
      expect(state.soundscapeVolume, 0.7);
      expect(state.isDeepFocusEnabled, isFalse);
    });

    test('startTimer, pauseTimer and toggleTimer manage running state', () {
      expect(controller.state.isRunning, isFalse);

      controller.startTimer();
      expect(controller.state.isRunning, isTrue);

      controller.pauseTimer();
      expect(controller.state.isRunning, isFalse);

      controller.toggleTimer();
      expect(controller.state.isRunning, isTrue);

      controller.toggleTimer();
      expect(controller.state.isRunning, isFalse);
    });

    test('resetInterval restores remainingSeconds to total duration', () {
      controller.selectIntervalType(PomodoroIntervalType.focus);
      controller.resetInterval();
      expect(controller.state.remainingSeconds, 1500);
      expect(controller.state.isRunning, isFalse);
    });

    test('selectIntervalType switches between focus, shortBreak, and longBreak', () {
      controller.selectIntervalType(PomodoroIntervalType.shortBreak);
      expect(controller.state.intervalType, PomodoroIntervalType.shortBreak);
      expect(controller.state.totalSeconds, 300);
      expect(controller.state.remainingSeconds, 300);
      expect(controller.state.formattedRemainingTime, '05:00');

      controller.selectIntervalType(PomodoroIntervalType.longBreak);
      expect(controller.state.intervalType, PomodoroIntervalType.longBreak);
      expect(controller.state.totalSeconds, 900);
      expect(controller.state.remainingSeconds, 900);
      expect(controller.state.formattedRemainingTime, '15:00');

      controller.selectIntervalType(PomodoroIntervalType.focus);
      expect(controller.state.intervalType, PomodoroIntervalType.focus);
      expect(controller.state.totalSeconds, 1500);
      expect(controller.state.remainingSeconds, 1500);
      expect(controller.state.formattedRemainingTime, '25:00');
    });

    test('updateObjective updates trimmed non-empty objective', () {
      controller.updateObjective('   Preparación Examen de Cálculo   ');
      expect(controller.state.currentObjective, 'Preparación Examen de Cálculo');

      // Empty string should not overwrite
      controller.updateObjective('   ');
      expect(controller.state.currentObjective, 'Preparación Examen de Cálculo');
    });

    test('toggleSoundscapeTrack toggles track playing state or changes track', () {
      controller.toggleSoundscapeTrack('rain');
      expect(controller.state.selectedSoundscapeId, 'rain');
      expect(controller.state.isSoundscapePlaying, isTrue);

      // Same track toggles off
      controller.toggleSoundscapeTrack('rain');
      expect(controller.state.isSoundscapePlaying, isFalse);

      // Different track selects it and starts playing
      controller.toggleSoundscapeTrack('waves');
      expect(controller.state.selectedSoundscapeId, 'waves');
      expect(controller.state.isSoundscapePlaying, isTrue);
    });

    test('setSoundscapeVolume clamps volume between 0.0 and 1.0', () {
      controller.setSoundscapeVolume(0.5);
      expect(controller.state.soundscapeVolume, 0.5);

      controller.setSoundscapeVolume(1.5);
      expect(controller.state.soundscapeVolume, 1.0);

      controller.setSoundscapeVolume(-0.2);
      expect(controller.state.soundscapeVolume, 0.0);
    });

    test('toggleDeepFocus toggles flag', () {
      expect(controller.state.isDeepFocusEnabled, isFalse);
      controller.toggleDeepFocus(true);
      expect(controller.state.isDeepFocusEnabled, isTrue);
      controller.toggleDeepFocus(false);
      expect(controller.state.isDeepFocusEnabled, isFalse);
    });

    test('skipInterval triggers transition to next interval', () {
      expect(controller.state.intervalType, PomodoroIntervalType.focus);
      controller.skipInterval();
      expect(controller.state.intervalType, PomodoroIntervalType.shortBreak);
      expect(controller.state.remainingSeconds, 300);
    });
  });
}
