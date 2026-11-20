import 'package:flutter/material.dart';
import '../../../../core/design_system/avatars/mind_user_avatar.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/design_system/notifications/notification_tray_modal.dart';
import '../../../../core/theme/mind_colors.dart';

/// Cabecera oficial serena de "Mi Diario Personal" acorde al diseño de Figma.
class JournalHeader extends StatelessWidget {
  const JournalHeader({
    super.key,
    required this.onBack,
    this.onNotification,
    this.onProfile,
    this.avatarUrl,
  });

  final VoidCallback onBack;
  final VoidCallback? onNotification;
  final VoidCallback? onProfile;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: MindColors.textPrimary,
                ),
                splashRadius: 22,
                tooltip: 'Volver',
              ),
              const SizedBox(width: 4),
              const MindAppLogo(size: 28),
            ],
          ),
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
                'Minduc — Diario\nPersonal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                  color: MindColors.textSecondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: onNotification ?? () => NotificationTrayModal.show(context),
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 24,
                      color: MindColors.textPrimary,
                    ),
                    splashRadius: 22,
                    tooltip: 'Notificaciones',
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: MindColors.estudioTrabajoAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              MindUserAvatar(
                avatarId: avatarUrl,
                size: 34,
                onTap: onProfile,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

