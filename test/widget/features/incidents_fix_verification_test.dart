import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/breathing/domain/entities/breathing_technique.dart';
import 'package:minduc/features/breathing/presentation/widgets/technique_selector_row.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/blocked_app.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/pomodoro_state.dart';
import 'package:minduc/features/focus_pomodoro/domain/services/soundscape_audio_service.dart';
import 'package:minduc/features/focus_pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:minduc/features/focus_pomodoro/presentation/screens/pomodoro_screen.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/app_selection_modal.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/pomodoro_timer_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAudioService extends SoundscapeAudioService {
  bool stopCalled = false;
  bool playCalled = false;
  String? lastPlayedTrack;

  @override
  Future<bool> playTrack(String trackId, {double? volume}) async {
    playCalled = true;
    lastPlayedTrack = trackId;
    return true;
  }

  @override
  Future<void> stop() async {
    stopCalled = true;
  }

  @override
  Future<void> pause() async {
    stopCalled = true;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Incident 1: Breathing Session Overflow Fix', () {
    testWidgets('TechniqueSelectorRow does NOT overflow on narrow 320px viewport with long technique name',
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const longTechnique = BreathingTechnique(
        id: 'energizante',
        name: 'Respiración Energizante y Dinámica',
        description: 'Técnica avanzada para elevar el estado de alerta',
        inhaleSeconds: 4,
        holdSeconds: 0,
        exhaleSeconds: 4,
        postHoldSeconds: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TechniqueSelectorRow(
                currentTechnique: longTechnique,
                currentCycle: 1,
                totalCycles: 12,
                onTechniqueChanged: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Ciclo 1 de 12'), findsOneWidget);
      expect(find.byType(TechniqueSelectorRow), findsOneWidget);
    });
  });

  group('Incident 2: Pomodoro Controls Overflow Fix', () {
    testWidgets('PomodoroTimerCard does NOT overflow on narrow 320px viewport with Iniciar enfoque button',
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const state = PomodoroState(
        currentObjective: 'Lectura de Psicología Cognitiva',
        remainingSeconds: 1500,
        totalSeconds: 1500,
        isRunning: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PomodoroTimerCard(
                state: state,
                onToggleTimer: () {},
                onResetInterval: () {},
                onSkipInterval: () {},
                onEditObjective: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Iniciar enfoque'), findsOneWidget);
      expect(find.byIcon(Icons.skip_next_rounded), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
    });
  });

  group('Incident 3: Ambient Sound Persistence Across Screens', () {
    testWidgets('Ambient sound continues playing automatically when changing screens',
        (tester) async {
      final mockAudio = MockAudioService();
      final container = ProviderContainer(
        overrides: [
          soundscapeAudioServiceProvider.overrideWithValue(mockAudio),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: PomodoroScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Iniciar sonido ambiental
      container.read(pomodoroControllerProvider.notifier).playSoundscape();
      await tester.pumpAndSettle();

      expect(container.read(pomodoroControllerProvider).isSoundscapePlaying, isTrue);

      // Desmontar PomodoroScreen (simulando navegación a otra pantalla/tab)
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: Text('Otra Pestaña')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // El sonido debe continuar activo y no haberse detenido
      expect(mockAudio.stopCalled, isFalse);
      expect(container.read(pomodoroControllerProvider).isSoundscapePlaying, isTrue);
    });
  });

  group('Incident 4: Blocked Apps Selection and Responsiveness', () {
    testWidgets('Allows selecting and unchecking multiple apps, adding custom apps, updating UI instantly',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final List<String> toggledApps = [];
      String? addedApp;

      final apps = [
        const BlockedApp(
          id: 'instagram',
          name: 'Instagram',
          packageName: 'com.instagram.android',
          category: 'Redes sociales',
          isBlocked: false,
        ),
        const BlockedApp(
          id: 'tiktok',
          name: 'TikTok',
          packageName: 'com.zhiliaoapp.musically',
          category: 'Redes sociales',
          isBlocked: false,
        ),
        const BlockedApp(
          id: 'youtube',
          name: 'YouTube',
          packageName: 'com.google.android.youtube',
          category: 'Entretenimiento',
          isBlocked: true,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSelectionModal(
              availableApps: apps,
              currentDurationMinutes: 25,
              onToggleApp: (appId, isBlocked) {
                toggledApps.add('$appId:$isBlocked');
              },
              onAddCustomApp: (name) {
                addedApp = name;
              },
              onDurationChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica estado inicial: 1 seleccionada (YouTube)
      expect(find.text('Guardar preferencias (1 seleccionadas)'), findsOneWidget);

      // 1. Marcar Instagram (selección de múltiples apps)
      await tester.tap(find.text('Instagram'));
      await tester.pumpAndSettle();

      expect(toggledApps, contains('instagram:true'));
      expect(find.text('Guardar preferencias (2 seleccionadas)'), findsOneWidget);

      // 2. Marcar TikTok
      await tester.tap(find.text('TikTok'));
      await tester.pumpAndSettle();

      expect(toggledApps, contains('tiktok:true'));
      expect(find.text('Guardar preferencias (3 seleccionadas)'), findsOneWidget);

      // 3. Desmarcar YouTube (quitar de la lista de bloqueo)
      await tester.tap(find.text('YouTube'));
      await tester.pumpAndSettle();

      expect(toggledApps, contains('youtube:false'));
      expect(find.text('Guardar preferencias (2 seleccionadas)'), findsOneWidget);

      // 4. Agregar nueva aplicación personalizada
      await tester.tap(find.text('Agregar otra app'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'BeReal');
      await tester.tap(find.text('Agregar'));
      await tester.pump();

      expect(addedApp, 'BeReal');
      expect(find.text('BeReal'), findsOneWidget);
      expect(find.text('Guardar preferencias (3 seleccionadas)'), findsOneWidget);
    });

    testWidgets('AppSelectionModal blocking period chips do NOT overflow by 56px on narrow 320px screen',
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSelectionModal(
              availableApps: const [
                BlockedApp(
                  id: 'instagram',
                  name: 'Instagram',
                  packageName: 'com.instagram.android',
                  category: 'Redes Sociales',
                  isBlocked: false,
                ),
              ],
              currentDurationMinutes: 25,
              onToggleApp: (_, __) {},
              onAddCustomApp: (_) {},
              onDurationChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Período de bloqueo:'), findsOneWidget);
      expect(find.text('25 min (Pomodoro)'), findsOneWidget);
    });
  });
}
