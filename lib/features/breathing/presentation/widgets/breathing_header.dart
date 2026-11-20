import 'package:flutter/material.dart';
import 'package:minduc/core/design_system/avatars/mind_user_avatar.dart';
import 'package:minduc/core/design_system/branding/mind_app_logo.dart';
import 'package:minduc/core/design_system/notifications/notification_tray_modal.dart';
import 'package:minduc/core/theme/mind_colors.dart';

/// Barra de navegación superior serena según mockup de Figma:
/// Botón de retroceso, título centrado "Sesion Respiracion", subtítulo "mindUC",
/// campana de notificaciones y avatar interactivo del usuario.
class BreathingHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onProfile;
  final VoidCallback? onNotification;
  final String? avatarUrl;

  const BreathingHeader({
    super.key,
    this.onBack,
    this.onProfile,
    this.onNotification,
    this.avatarUrl,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // 1. Botón de retroceso y logotipo a la izquierda
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(color: MindColors.divider, width: 1),
                  ),
                  child: InkWell(
                    key: const Key('breathing_header_back_btn'),
                    customBorder: const CircleBorder(),
                    onTap: onBack ?? () => Navigator.of(context).maybePop(),
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: MindColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const MindAppLogo(size: 28),
              ],
            ),

            // 2. Título centrado y subtítulo sereno de mindUC
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sesion Respiracion',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: MindColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'mindUC',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: MindColors.primaryDark,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Campana de notificaciones y avatar interactivo de perfil
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    size: 22,
                    color: MindColors.textPrimary,
                  ),
                  onPressed: onNotification ?? () => NotificationTrayModal.show(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  key: const Key('breathing_header_profile_btn'),
                  onTap: onProfile,
                  child: MindUserAvatar(
                    avatarId: avatarUrl,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
