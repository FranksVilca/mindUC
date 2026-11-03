import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/soundscape_track.dart';

/// Sección de ambiente sonoro con selector horizontal de pistas relajantes
/// y control de volumen reactivo.
class SoundscapeSection extends StatelessWidget {
  const SoundscapeSection({
    super.key,
    required this.tracks,
    required this.selectedTrackId,
    required this.isPlaying,
    required this.volume,
    required this.onTrackTapped,
    required this.onVolumeChanged,
  });

  final List<SoundscapeTrack> tracks;
  final String? selectedTrackId;
  final bool isPlaying;
  final double volume;
  final ValueChanged<String> onTrackTapped;
  final ValueChanged<double> onVolumeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera de la sección
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.graphic_eq_rounded,
                  size: 20,
                  color: MindColors.textPrimary,
                ),
                SizedBox(width: 8),
                Text(
                  'Ambiente sonoro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: MindColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Audio relajante',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
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

        // Control de volumen deslizante
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
              const Icon(
                Icons.volume_down_rounded,
                size: 20,
                color: MindColors.textSecondary,
              ),
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
              const Icon(
                Icons.volume_up_rounded,
                size: 20,
                color: MindColors.textSecondary,
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

