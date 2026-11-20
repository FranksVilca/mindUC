import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/blocked_app.dart';
import '../../domain/entities/pomodoro_interval_type.dart';
import '../../domain/entities/soundscape_track.dart';
import '../../domain/services/soundscape_audio_service.dart';
import '../controllers/app_blocker_controller.dart';
import '../controllers/pomodoro_controller.dart';
import '../widgets/app_selection_modal.dart';
import '../widgets/deep_focus_card.dart';
import '../widgets/interval_selector_row.dart';
import '../widgets/objective_edit_dialog.dart';
import '../widgets/pomodoro_cycle_progress.dart';
import '../widgets/pomodoro_header.dart';
import '../widgets/pomodoro_timer_card.dart';
import '../widgets/soundscape_section.dart';

/// Pantalla principal de la sesión de Concentración Pomodoro de mindUC.
/// Articula el cronómetro diferencial, paisajes sonoros audibles exclusivos de esta pantalla y
/// el gestor de bloqueo transparente de aplicaciones distractoras.
class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen>
    with WidgetsBindingObserver {
  late PomodoroNotifier _pomodoroNotifier;
  late SoundscapeAudioService _audioService;
  static const MethodChannel _blockerChannel =
      MethodChannel('com.minduc.minduc/app_blocker');

  @override
  void initState() {
    super.initState();
    _pomodoroNotifier = ref.read(pomodoroControllerProvider.notifier);
    _audioService = ref.read(soundscapeAudioServiceProvider);
    WidgetsBinding.instance.addObserver(this);

    _blockerChannel.setMethodCallHandler((call) async {
      if (call.method == 'onAppBlocked' && mounted) {
        final pkg = call.arguments is Map
            ? (call.arguments['package'] as String? ?? 'esta aplicación')
            : 'esta aplicación';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MindColors.primaryDark,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            content: Row(
              children: [
                const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '🌿 Enfoque Profundo activo: Se pausó el acceso a $pkg para proteger tu concentración.',
                    style: const TextStyle(fontSize: 12.5, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(appBlockerControllerProvider.notifier).refreshPermissionStatus();
    } else if (state == AppLifecycleState.paused) {
      final pomodoroState = ref.read(pomodoroControllerProvider);
      final blockerState = ref.read(appBlockerControllerProvider);
      if (pomodoroState.isRunning &&
          pomodoroState.intervalType == PomodoroIntervalType.focus &&
          blockerState.isBlockerEnabled &&
          blockerState.blockedApps.isNotEmpty) {
        NotificationService.instance.showDeepFocusDistractionNotice(
          blockedCount: blockerState.blockedApps.length,
        );
      }
    } else if (state == AppLifecycleState.detached) {
      _audioService.stop();
      _pomodoroNotifier.stopSoundscape();
    }
  }

  @override
  void dispose() {
    _blockerChannel.setMethodCallHandler(null);
    WidgetsBinding.instance.removeObserver(this);
    // El ambiente sonoro activo continúa en segundo plano al cambiar de pantalla
    super.dispose();
  }

  void _handleExit() {
    if (!context.mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pomodoroControllerProvider);
    final notifier = ref.read(pomodoroControllerProvider.notifier);
    final blockerState = ref.watch(appBlockerControllerProvider);
    final blockerNotifier = ref.read(appBlockerControllerProvider.notifier);

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: MindColors.background,
        body: SafeArea(
          child: Column(
            children: [
              PomodoroHeader(
                onBack: _handleExit,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Progreso de ciclos de la sesión
                      PomodoroCycleProgress(
                        sessionTitle: state.sessionTitle,
                        currentCycle: state.currentCycle,
                        totalCycles: state.totalCycles,
                      ),
                      const SizedBox(height: 16),

                      // Selector segmentado de intervalo (Enfoque, Corto, Largo)
                      IntervalSelectorRow(
                        selectedType: state.intervalType,
                        onTypeSelected: notifier.selectIntervalType,
                      ),
                      const SizedBox(height: 16),

                      // Tarjeta principal con cronómetro y controles
                      PomodoroTimerCard(
                        state: state,
                        onToggleTimer: notifier.toggleTimer,
                        onResetInterval: notifier.resetInterval,
                        onSkipInterval: notifier.skipInterval,
                        onEditObjective: () {
                          ObjectiveEditDialog.show(
                            context,
                            initialObjective: state.currentObjective,
                            onSave: notifier.updateObjective,
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Sección de ambiente sonoro, reproducción continua y volumen
                      SoundscapeSection(
                        tracks: SoundscapeTrack.defaultTracks,
                        selectedTrackId: state.selectedSoundscapeId,
                        isPlaying: state.isSoundscapePlaying,
                        volume: state.soundscapeVolume,
                        onTrackTapped: notifier.toggleSoundscapeTrack,
                        onVolumeChanged: notifier.setSoundscapeVolume,
                        onPlay: notifier.playSoundscape,
                        onPause: notifier.pauseSoundscape,
                        onStop: notifier.stopSoundscape,
                      ),
                      const SizedBox(height: 24),

                      // Modo enfoque profundo con bloqueo transparente de aplicaciones
                      DeepFocusCard(
                        isEnabled: blockerState.isBlockerEnabled,
                        onToggle: (enabled) {
                          blockerNotifier.toggleBlocker(enabled);
                          notifier.toggleDeepFocus(enabled);
                        },
                        status: blockerState.status,
                        blockedApps: blockerState.blockedApps,
                        availableApps: blockerState.availableApps,
                        blockingDurationMinutes:
                            blockerState.blockingDurationMinutes,
                        onToggleApp: (appId, isBlocked) {
                          blockerNotifier.toggleAppSelection(appId, isBlocked);
                        },
                        onSelectApps: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => Consumer(
                              builder: (context, ref, _) {
                                final liveBlockerState =
                                    ref.watch(appBlockerControllerProvider);
                                return AppSelectionModal(
                                  availableApps: liveBlockerState.availableApps.isNotEmpty
                                      ? liveBlockerState.availableApps
                                      : BlockedApp.defaultApps,
                                  currentDurationMinutes:
                                      liveBlockerState.blockingDurationMinutes,
                                  onToggleApp: (appId, isBlocked) {
                                    ref
                                        .read(appBlockerControllerProvider.notifier)
                                        .toggleAppSelection(appId, isBlocked);
                                  },
                                  onAddCustomApp: (name) {
                                    ref
                                        .read(appBlockerControllerProvider.notifier)
                                        .addCustomApp(name);
                                  },
                                  onDurationChanged: (duration) {
                                    ref
                                        .read(appBlockerControllerProvider.notifier)
                                        .setBlockingDuration(duration);
                                  },
                                );
                              },
                            ),
                          );
                        },
                        onRemoveApp: (appId) {
                          blockerNotifier.removeBlockedApp(appId);
                        },
                        onRequestPermissions: () {
                          blockerNotifier.requestPermissions();
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
