import 'package:flutter/material.dart';
import '../../../../core/design_system/avatars/mind_user_avatar.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/design_system/notifications/notification_tray_modal.dart';
import '../../../../core/theme/mind_colors.dart';

/// Cabecera de la pestaña "Mi Agenda consciente" acorde al diseño de Figma.
class AgendaHeader extends StatelessWidget {
  const AgendaHeader({
    super.key,
    this.onNotification,
    this.onProfile,
    this.avatarUrl,
  });

  final VoidCallback? onNotification;
  final VoidCallback? onProfile;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logotipo oficial a la izquierda
          const SizedBox(
            width: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: MindAppLogo(size: 32),
            ),
          ),

          // Título centrado con marca
          const Column(
            children: [
              Text(
                'mindUC',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: MindColors.primaryDark,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Agenda',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: MindColors.textSecondary,
                ),
              ),
            ],
          ),

          // Acciones: Notificaciones y Avatar
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: onNotification ?? () => NotificationTrayModal.show(context),
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: MindColors.textPrimary,
                      size: 22,
                    ),
                    splashRadius: 20,
                    tooltip: 'Notificaciones',
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD66885),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              MindUserAvatar(
                avatarId: avatarUrl,
                size: 32,
                onTap: onProfile,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

