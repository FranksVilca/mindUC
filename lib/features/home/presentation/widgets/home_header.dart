import 'package:flutter/material.dart';
import '../../../../core/design_system/avatars/mind_user_avatar.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';

/// Cabecera superior del Dashboard según Figma: marca mindUC, subtítulo, campana y avatar.
class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onAvatarPressed;
  final String? avatarUrl;

  const HomeHeader({
    super.key,
    this.onNotificationPressed,
    this.onAvatarPressed,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logotipo oficial a la izquierda
          const Align(
            alignment: Alignment.centerLeft,
            child: MindAppLogo(size: 36),
          ),

          // Marca centrada
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'mindUC',
                style: MindTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: MindColors.primaryDark,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Inicio',
                style: MindTypography.labelSmall.copyWith(
                  color: MindColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Iconos a la derecha
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campana de notificaciones con badge sutil
                GestureDetector(
                  onTap: onNotificationPressed,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        size: 24,
                        color: MindColors.textPrimary,
                      ),
                      Positioned(
                        right: 1,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC5BEEB), // Lavanda pastel del mockup
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Avatar circular de usuario
                MindUserAvatar(
                  avatarId: avatarUrl,
                  size: 34,
                  onTap: onAvatarPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

