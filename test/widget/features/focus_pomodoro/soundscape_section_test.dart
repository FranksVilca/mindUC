import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/soundscape_track.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/soundscape_section.dart';

void main() {
  group('SoundscapeSection Widget Tests', () {
    testWidgets('renders section title, track cards and slider', (tester) async {
      String? tappedTrackId;
      double changedVolume = 0.7;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SoundscapeSection(
                tracks: SoundscapeTrack.defaultTracks,
                selectedTrackId: 'rain',
                isPlaying: true,
                volume: 0.7,
                onTrackTapped: (id) => tappedTrackId = id,
                onVolumeChanged: (vol) => changedVolume = vol,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Ambiente sonoro'), findsOneWidget);
      expect(find.text('Audio relajante'), findsOneWidget);
      expect(find.text('Lluvia campus'), findsOneWidget);
      expect(find.text('En reproducción'), findsOneWidget);
      expect(find.text('Cafetería calma'), findsOneWidget);
      expect(find.text('Bosque natural'), findsOneWidget);

      // Tocar Cafetería calma
      await tester.tap(find.text('Cafetería calma'));
      await tester.pump();
      expect(tappedTrackId, 'cafe');

      // Deslizar volumen
      await tester.drag(find.byType(Slider), const Offset(-50, 0));
      await tester.pump();
      expect(changedVolume != 0.7, isTrue);
    });
  });
}

