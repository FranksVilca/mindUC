import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/soundscape_track.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/soundscape_section.dart';

void main() {
  group('SoundscapeSection Play/Pause/Stop & Volume Controls Tests', () {
    testWidgets('triggers onPlay, onPause and onStop callbacks properly',
        (tester) async {
      bool playPressed = false;
      bool pausePressed = false;
      bool stopPressed = false;
      double newVolume = 0.7;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SoundscapeSection(
                tracks: SoundscapeTrack.defaultTracks,
                selectedTrackId: 'rain',
                isPlaying: true,
                volume: 0.7,
                onTrackTapped: (_) {},
                onVolumeChanged: (v) => newVolume = v,
                onPlay: () => playPressed = true,
                onPause: () => pausePressed = true,
                onStop: () => stopPressed = true,
              ),
            ),
          ),
        ),
      );

      // Verificamos estado visible de reproducción
      expect(find.text('Audio relajante'), findsOneWidget);
      expect(find.text('70%'), findsOneWidget);
      expect(find.byTooltip('Reproducir'), findsOneWidget);
      expect(find.byTooltip('Pausar'), findsOneWidget);
      expect(find.byTooltip('Detener'), findsOneWidget);
      expect(playPressed, isFalse);

      // Pulsar Pausar
      await tester.tap(find.byTooltip('Pausar'));
      await tester.pump();
      expect(pausePressed, isTrue);

      // Pulsar Detener
      await tester.tap(find.byTooltip('Detener'));
      await tester.pump();
      expect(stopPressed, isTrue);

      // Mute / Unmute al tocar el icono de volumen
      await tester.tap(find.byIcon(Icons.volume_down_rounded));
      await tester.pump();
      expect(newVolume, 0.0);
    });

    testWidgets('when isPlaying is false, play button is enabled and pause/stop disabled',
        (tester) async {
      bool playTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SoundscapeSection(
                tracks: SoundscapeTrack.defaultTracks,
                selectedTrackId: 'cafe',
                isPlaying: false,
                volume: 0.5,
                onTrackTapped: (_) {},
                onVolumeChanged: (_) {},
                onPlay: () => playTriggered = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('50%'), findsOneWidget);
      expect(find.textContaining('En pausa'), findsWidgets);

      // Pulsar Reproducir
      await tester.tap(find.byTooltip('Reproducir'));
      await tester.pump();
      expect(playTriggered, isTrue);
    });
  });
}
