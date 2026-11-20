import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';
import '../../domain/entities/app_avatar.dart';

/// Selector interactivo y moderno para elegir uno de los 3 avatares de animales
/// (🐼 Oso panda, 🐨 Koala, 🐯 Tigre) durante el registro o edición de perfil.
class AvatarSelectorRow extends StatelessWidget {
  final String selectedAvatarId;
  final ValueChanged<AppAvatar> onAvatarSelected;

  const AvatarSelectorRow({
    super.key,
    required this.selectedAvatarId,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Elige tu avatar de perfil',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MindTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: MindColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: MindColors.bienestarPill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '3 animales',
                style: MindTypography.labelSmall.copyWith(
                  color: MindColors.primaryDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Selecciona el animal que mejor represente tu momento de calma',
          style: MindTypography.bodyMedium.copyWith(
            color: MindColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),

        // Fila de 3 tarjetas de avatares
        Row(
          children: AppAvatar.all.map((avatar) {
            final isSelected =
                avatar.id == AppAvatar.fromId(selectedAvatarId).id;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _AvatarOptionCard(
                  avatar: avatar,
                  isSelected: isSelected,
                  onTap: () => onAvatarSelected(avatar),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AvatarOptionCard extends StatelessWidget {
  final AppAvatar avatar;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarOptionCard({
    required this.avatar,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('avatar_choice_${avatar.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF9FAF9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? MindColors.primary : Colors.grey.shade200,
            width: isSelected ? 2.2 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: MindColors.primary.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Círculo con el emoji del animal y badge de selección
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: avatar.backgroundColor,
                    border: Border.all(
                      color: isSelected
                          ? avatar.accentColor
                          : avatar.accentColor.withValues(alpha: 0.2),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      avatar.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    right: -4,
                    bottom: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: MindColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Nombre del animal
            Text(
              avatar.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? MindColors.textPrimary
                    : MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),

            // Breve descripción o significado
            Text(
              avatar.description,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                color: isSelected
                    ? MindColors.primaryDark
                    : MindColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
