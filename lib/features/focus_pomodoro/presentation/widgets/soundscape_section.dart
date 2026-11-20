import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/soundscape_track.dart';

/// Sección de ambiente sonoro con selector de pistas relajantes,
/// botones de reproducir, pausar y detener, control de volumen reactivo
/// e indicador visible del estado de reproducción.
class SoundscapeSection extends StatelessWidget {
  const SoundscapeSection({
    super.key,
    required this.tracks,
    required this.selectedTrackId,
    required this.isPlaying,
    required this.volume,
    required this.onTrackTapped,
    required this.onVolumeChanged,
    this.onPlay,
    this.onPause,
    this.onStop,
  });

  final List<SoundscapeTrack> tracks;
  final String? selectedTrackId;
  final bool isPlaying;
  final double volume;
  final ValueChanged<String> onTrackTapped;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final activeTrack = tracks.firstWhere(
      (t) => t.id == selectedTrackId,
      orElse: () => tracks.isNotEmpty ? tracks.first : SoundscapeTrack.defaultTracks.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera de la sección con indicador visual de estado
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.graphic_eq_rounded,
                    size: 20,
                    color: MindColors.textPrimary,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ambiente sonoro',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: MindColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isPlaying ? const Color(0xFFE2F0E7) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPlaying) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: MindColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    'Audio relajante',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? MindColors.primaryDark : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Carrusel horizontal de tarjetas de sonido
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: tracks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final track = tracks[index];
              final isSelected = track.id == selectedTrackId;
              final isTrackActive = isSelected && isPlaying;

              return _SoundscapeCard(
                track: track,
                isSelected: isSelected,
                isActive: isTrackActive,
                onTap: () => onTrackTapped(track.id),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Botones de control: Reproducir, Pausar y Detener
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Etiqueta de la pista activa
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      isPlaying ? Icons.play_circle_filled_rounded : Icons.pause_circle_outline_rounded,
                      size: 20,
                      color: isPlaying ? MindColors.primary : MindColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isPlaying
                            ? '${activeTrack.title} (${activeTrack.subtitle})'
                            : '${activeTrack.title} (En pausa)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPlaying ? MindColors.primaryDark : MindColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Botones de acción
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón Reproducir / Iniciar
                  IconButton(
                    tooltip: 'Reproducir',
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 24,
                      color: isPlaying ? Colors.grey.shade400 : MindColors.primary,
                    ),
                    onPressed: isPlaying ? null : (onPlay ?? () => onTrackTapped(activeTrack.id)),
                  ),

                  // Botón Pausar
                  IconButton(
                    tooltip: 'Pausar',
                    icon: Icon(
                      Icons.pause_rounded,
                      size: 22,
                      color: isPlaying ? const Color(0xFFE65100) : Colors.grey.shade400,
                    ),
                    onPressed: isPlaying ? (onPause ?? () => onTrackTapped(activeTrack.id)) : null,
                  ),

                  // Botón Detener
                  IconButton(
                    tooltip: 'Detener',
                    icon: Icon(
                      Icons.stop_rounded,
                      size: 22,
                      color: isPlaying ? Colors.red.shade600 : Colors.grey.shade400,
                    ),
                    onPressed: isPlaying ? onStop : null,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Control de volumen deslizante con indicador de porcentaje
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  volume <= 0.01 ? Icons.volume_off_rounded : Icons.volume_down_rounded,
                  size: 20,
                  color: MindColors.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onVolumeChanged(volume > 0 ? 0.0 : 0.5),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                    activeTrackColor: MindColors.primary,
                    inactiveTrackColor: Colors.grey.shade200,
                    thumbColor: MindColors.primaryDark,
                    overlayColor: MindColors.primary.withValues(alpha: 0.15),
                  ),
                  child: Slider(
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: onVolumeChanged,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${(volume * 100).round()}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: MindColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(
                  Icons.volume_up_rounded,
                  size: 20,
                  color: MindColors.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onVolumeChanged(1.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SoundscapeCard extends StatelessWidget {
  const _SoundscapeCard({
    required this.track,
    required this.isSelected,
    required this.isActive,
    required this.onTap,
  });

  final SoundscapeTrack track;
  final bool isSelected;
  final bool isActive;
  final VoidCallback onTap;

  IconData _resolveIcon(String name) {
    switch (name) {
      case 'cloud':
        return Icons.cloud_rounded;
      case 'coffee':
        return Icons.local_cafe_rounded;
      case 'forest':
        return Icons.park_rounded;
      default:
        return Icons.music_note_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSubtitle = isSelected
        ? (isActive ? 'En reproducción' : 'En pausa')
        : track.subtitle;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? MindColors.primary : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? MindColors.primary.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? MindColors.bienestarPill
                    : Colors.grey.shade100,
              ),
              child: Icon(
                _resolveIcon(track.iconName),
                size: 18,
                color: isSelected
                    ? MindColors.primaryDark
                    : MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              track.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: MindColors.textPrimary,
              ),
            ),
            Text(
              effectiveSubtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: isSelected && isActive
                    ? MindColors.primary
                    : MindColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
