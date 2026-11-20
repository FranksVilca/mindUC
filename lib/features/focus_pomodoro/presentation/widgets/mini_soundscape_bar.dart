import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/soundscape_track.dart';
import '../controllers/pomodoro_controller.dart';

/// Mini reproductor flotante que se muestra en la parte inferior de la aplicación
/// cuando un ambiente sonoro de la sección Pomodoro está activo.
/// Permite escuchar el sonido al cambiar de pantalla, pausar, reanudar, detener
/// o regresar instantáneamente a la pantalla de Pomodoro.
class MiniSoundscapeBar extends ConsumerWidget {
  const MiniSoundscapeBar({super.key});

  IconData _resolveIcon(String name) {
    switch (name) {
      case 'cloud':
        return Icons.cloud_rounded;
      case 'coffee':
        return Icons.local_cafe_rounded;
      case 'forest':
        return Icons.park_rounded;
      default:
        return Icons.graphic_eq_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Optimización: Suscripción selectiva para evitar rebuilds con cada tick de 1s del cronómetro
    final isSoundscapePlaying = ref.watch(
      pomodoroControllerProvider.select((s) => s.isSoundscapePlaying),
    );

    // Solo se muestra si el sonido está reproduciéndose o si está pausado con una pista seleccionada
    if (!isSoundscapePlaying) {
      return const SizedBox.shrink();
    }

    final selectedSoundscapeId = ref.watch(
      pomodoroControllerProvider.select((s) => s.selectedSoundscapeId),
    );
    final notifier = ref.read(pomodoroControllerProvider.notifier);

    final activeTrack = SoundscapeTrack.defaultTracks.firstWhere(
      (t) => t.id == selectedSoundscapeId,
      orElse: () => SoundscapeTrack.defaultTracks.first,
    );

    return Material(
      key: const Key('mini_soundscape_bar'),
      color: const Color(0xFFEDF5F0),
      child: InkWell(
        onTap: () {
          // Permite volver a la pantalla de Pomodoro desde cualquier pestaña
          context.push(AppRoutes.pomodoroSession);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFD1E4D7),
                width: 1.0,
              ),
              bottom: BorderSide(
                color: Color(0xFFD1E4D7),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // Icono temático del ambiente sonoro en píldora circular
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E6347),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _resolveIcon(activeTrack.iconName),
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),

              // Información del ambiente sonoro
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            activeTrack.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: MindColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9EADB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Pomodoro',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E6347),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isSoundscapePlaying
                          ? 'Ambiente activo en segundo plano • Toca para ver'
                          : 'Ambiente en pausa • Toca para volver',
                      style: const TextStyle(
                        fontSize: 11,
                        color: MindColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Control rápido: Pausar / Reanudar
              IconButton(
                key: const Key('mini_soundscape_play_pause_btn'),
                icon: Icon(
                  isSoundscapePlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                  size: 28,
                  color: const Color(0xFF2E6347),
                ),
                tooltip: isSoundscapePlaying
                    ? 'Pausar ambiente'
                    : 'Reanudar ambiente',
                onPressed: () {
                  if (isSoundscapePlaying) {
                    notifier.pauseSoundscape();
                  } else {
                    notifier.playSoundscape();
                  }
                },
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),

              const SizedBox(width: 4),

              // Control rápido: Detener por completo
              IconButton(
                key: const Key('mini_soundscape_stop_btn'),
                icon: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: MindColors.textSecondary,
                ),
                tooltip: 'Detener sonido',
                onPressed: () {
                  notifier.stopSoundscape();
                },
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
