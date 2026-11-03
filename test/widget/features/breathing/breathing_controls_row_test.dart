import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/breathing/presentation/widgets/breathing_controls_row.dart';

void main() {
  group('BreathingControlsRow Widget Tests', () {
    testWidgets('renders play/pause, reset and stop buttons when running', (tester) async {
      bool resetCalled = false;
      bool playPauseCalled = false;
      bool stopCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BreathingControlsRow(
              isRunning: true,
              onReset: () => resetCalled = true,
              onPlayPause: () => playPauseCalled = true,
              onStop: () => stopCalled = true,
            ),
          ),
        ),
      );

      // Main button should show "Pausar sesión" and pause icon
      expect(find.text('Pausar sesión'), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsOneWidget);

      // Reset and stop icons
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);

      // Tap on reset
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();
      expect(resetCalled, isTrue);

      // Tap on play/pause
      await tester.tap(find.text('Pausar sesión'));
      await tester.pump();
      expect(playPauseCalled, isTrue);

      // Tap on stop
      await tester.tap(find.byIcon(Icons.stop));
      await tester.pump();
      expect(stopCalled, isTrue);
    });

    testWidgets('renders "Iniciar sesión" when isRunning is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BreathingControlsRow(
              isRunning: false,
              onReset: () {},
              onPlayPause: () {},
              onStop: () {},
            ),
          ),
        ),
      );

      expect(find.text('Iniciar sesión'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });
  });
}
