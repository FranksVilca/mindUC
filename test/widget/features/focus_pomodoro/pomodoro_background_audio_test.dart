import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/focus_pomodoro/domain/services/soundscape_audio_service.dart';
import 'package:minduc/features/focus_pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:minduc/features/focus_pomodoro/presentation/screens/pomodoro_screen.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/mini_soundscape_bar.dart';

class TestSoundscapeAudioService extends SoundscapeAudioService {
  String? lastPlayedTrack;
  bool isAudioPlaying = false;
  bool stopWasCalled = false;
  bool pauseWasCalled = false;

  @override
  Future<bool> playTrack(String trackId, {double? volume}) async {
    lastPlayedTrack = trackId;
    isAudioPlaying = true;
    return true;
  }

  @override
  Future<void> pause() async {
    isAudioPlaying = false;
    pauseWasCalled = true;
  }

  @override
  Future<void> stop() async {
    isAudioPlaying = false;
    stopWasCalled = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pomodoro Background Audio on Screen Change Tests', () {
    testWidgets(
      'Soundscape keeps playing when user exits PomodoroScreen (navigates back)',
      (tester) async {
        final testAudioService = TestSoundscapeAudioService();
        final container = ProviderContainer(
          overrides: [
            soundscapeAudioServiceProvider.overrideWithValue(testAudioService),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: MindTheme.lightTheme,
              home: Builder(
                builder: (context) {
                  return Scaffold(
                    body: Center(
                      child: ElevatedButton(
                        child: const Text('Abrir Pomodoro'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const PomodoroScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Abrir PomodoroScreen
        await tester.tap(find.text('Abrir Pomodoro'));
        await tester.pumpAndSettle();

        expect(find.byType(PomodoroScreen), findsOneWidget);

        // 2. Iniciar ambiente sonoro desde el controlador
        final notifier = container.read(pomodoroControllerProvider.notifier);
        notifier.playSoundscape();
        await tester.pumpAndSettle();

        expect(container.read(pomodoroControllerProvider).isSoundscapePlaying, isTrue);
        expect(testAudioService.lastPlayedTrack, 'rain');
        expect(testAudioService.stopWasCalled, isFalse);

        // 3. Salir de PomodoroScreen tocando el botón de retroceso (Volver)
        final backButton = find.byTooltip('Volver');
        expect(backButton, findsOneWidget);
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Verificamos que volvimos a la pantalla anterior
        expect(find.byType(PomodoroScreen), findsNothing);
        expect(find.text('Abrir Pomodoro'), findsOneWidget);

        // REQUISITO CLAVE: El sonido DEBE continuar activo al cambiar de pantalla
        expect(
          container.read(pomodoroControllerProvider).isSoundscapePlaying,
          isTrue,
          reason: 'El sonido ambiental debe seguir activo tras salir de PomodoroScreen',
        );
        expect(
          testAudioService.stopWasCalled,
          isFalse,
          reason: 'No se debe haber llamado a stop() al salir de PomodoroScreen',
        );
      },
    );

    testWidgets(
      'MiniSoundscapeBar displays active track name and allows pause, resume, and stop controls',
      (tester) async {
        final testAudioService = TestSoundscapeAudioService();
        final container = ProviderContainer(
          overrides: [
            soundscapeAudioServiceProvider.overrideWithValue(testAudioService),
          ],
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('Pantalla de Inicio / Dashboard'),
                ),
                bottomNavigationBar: MiniSoundscapeBar(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Inicialmente el sonido no está activo: MiniSoundscapeBar no se muestra
        expect(find.byKey(const Key('mini_soundscape_bar')), findsNothing);

        // Activamos sonido de Cafetería desde Pomodoro
        final notifier = container.read(pomodoroControllerProvider.notifier);
        notifier.toggleSoundscapeTrack('cafe');
        await tester.pumpAndSettle();

        // Ahora MiniSoundscapeBar es visible
        expect(find.byKey(const Key('mini_soundscape_bar')), findsOneWidget);
        expect(find.text('Cafetería calma'), findsOneWidget);
        expect(find.textContaining('Ambiente activo en segundo plano'), findsOneWidget);

        // Pulsar botón de pausa en el mini reproductor
        await tester.tap(find.byKey(const Key('mini_soundscape_play_pause_btn')));
        await tester.pumpAndSettle();

        expect(container.read(pomodoroControllerProvider).isSoundscapePlaying, isFalse);
        expect(testAudioService.pauseWasCalled, isTrue);

        // Al reactivar y luego detener por completo
        notifier.playSoundscape();
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('mini_soundscape_bar')), findsOneWidget);

        // Pulsar botón de cerrar/detener en el mini reproductor
        await tester.tap(find.byKey(const Key('mini_soundscape_stop_btn')));
        await tester.pumpAndSettle();

        expect(container.read(pomodoroControllerProvider).isSoundscapePlaying, isFalse);
        expect(testAudioService.stopWasCalled, isTrue);
        expect(find.byKey(const Key('mini_soundscape_bar')), findsNothing);
      },
    );
  });
}
