import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/soundscape_track.dart';
import 'package:minduc/features/focus_pomodoro/domain/services/soundscape_audio_service.dart';
import 'package:minduc/features/focus_pomodoro/presentation/controllers/pomodoro_controller.dart';

class MockAudioService extends SoundscapeAudioService {
  String? lastPlayedTrack;
  double? lastVolume;
  bool isPausedCalled = false;
  bool isStoppedCalled = false;
  bool isResumedCalled = false;

  @override
  Future<bool> playTrack(String trackId, {double? volume}) async {
    lastPlayedTrack = trackId;
    lastVolume = volume ?? 0.7;
    return true;
  }

  @override
  Future<void> pause() async {
    isPausedCalled = true;
  }

  @override
  Future<void> resume() async {
    isResumedCalled = true;
  }

  @override
  Future<void> stop() async {
    isStoppedCalled = true;
  }

  @override
  Future<void> setVolume(double newVolume) async {
    lastVolume = newVolume;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SoundscapeAudioService & SoundscapeTrack Tests', () {
    test('default tracks have correct audio assets and descriptions', () {
      const tracks = SoundscapeTrack.defaultTracks;
      expect(tracks.length, 3);

      final rain = tracks.firstWhere((t) => t.id == 'rain');
      expect(rain.title, 'Lluvia campus');
      expect(rain.effectiveAudioAsset, 'audio/rain.wav');

      final cafe = tracks.firstWhere((t) => t.id == 'cafe');
      expect(cafe.title, 'Cafetería calma');
      expect(cafe.effectiveAudioAsset, 'audio/cafe.wav');

      final forest = tracks.firstWhere((t) => t.id == 'forest');
      expect(forest.title, 'Bosque natural');
      expect(forest.effectiveAudioAsset, 'audio/forest.wav');
    });

    test('PomodoroNotifier connects with audio service on play, pause, and stop', () {
      final mockService = MockAudioService();
      final notifier = PomodoroNotifier(audioService: mockService);

      // Reproducir sonido
      notifier.playSoundscape();
      expect(notifier.state.isSoundscapePlaying, isTrue);
      expect(mockService.lastPlayedTrack, 'rain');

      // Pausar sonido
      notifier.pauseSoundscape();
      expect(notifier.state.isSoundscapePlaying, isFalse);
      expect(mockService.isPausedCalled, isTrue);

      // Detener sonido
      notifier.stopSoundscape();
      expect(notifier.state.isSoundscapePlaying, isFalse);
      expect(mockService.isStoppedCalled, isTrue);

      // Ajustar volumen
      notifier.setSoundscapeVolume(0.85);
      expect(notifier.state.soundscapeVolume, 0.85);
      expect(mockService.lastVolume, 0.85);
    });

    test('toggleSoundscapeTrack toggles between play and pause for same track', () {
      final mockService = MockAudioService();
      final notifier = PomodoroNotifier(audioService: mockService);

      notifier.toggleSoundscapeTrack('cafe');
      expect(notifier.state.selectedSoundscapeId, 'cafe');
      expect(notifier.state.isSoundscapePlaying, isTrue);
      expect(mockService.lastPlayedTrack, 'cafe');

      notifier.toggleSoundscapeTrack('cafe');
      expect(notifier.state.isSoundscapePlaying, isFalse);
      expect(mockService.isPausedCalled, isTrue);
    });
  });
}
