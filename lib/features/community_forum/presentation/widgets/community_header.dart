import 'package:flutter/material.dart';
import '../../../../core/design_system/avatars/mind_user_avatar.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/design_system/notifications/notification_tray_modal.dart';
import '../../../../core/theme/mind_colors.dart';

/// Cabecera serena de la Comunidad UC acorde al diseño de Figma.
class CommunityHeader extends StatelessWidget implements PreferredSizeWidget {
  const CommunityHeader({
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
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  key: const Key('community_header_back_btn'),
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
              mainAxisSize: MainAxisSize.min,
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
                  'Minduc — Comunidad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
                          color: Color(0xFFD66885),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  key: const Key('community_header_profile_btn'),
                  onTap: onProfile,
                  child: MindUserAvatar(
                    avatarId: avatarUrl,
                    size: 34,
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
