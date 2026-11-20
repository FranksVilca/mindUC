import 'package:flutter/material.dart';
import '../avatars/mind_user_avatar.dart';
import '../branding/mind_app_logo.dart';
import '../notifications/notification_tray_modal.dart';
import '../../theme/mind_colors.dart';
import '../../theme/mind_typography.dart';

/// Barra superior contextual oficial de mindUC presente en todas las vistas del shell.
class MindAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final String? avatarUrl;

  const MindAppBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.onProfileTap,
    this.showBackButton = false,
    this.onBackTap,
    this.avatarUrl,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showBackButton)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    color: MindColors.textPrimary,
                    onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 4),
                  const MindAppLogo(size: 26),
                ],
              )
            else
              const SizedBox(
                width: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: MindAppLogo(size: 32),
                ),
              ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'mindUC',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MindTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: MindColors.primaryDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MindTypography.labelSmall.copyWith(
                      color: MindColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.notifications_outlined, size: 22, color: MindColors.textPrimary),
                      Positioned(
                        right: -1,
                        top: -1,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: MindColors.estudioTrabajoAccent,
                        ),
                      ),
                    ],
                  ),
                  onPressed: onNotificationTap ?? () => NotificationTrayModal.show(context),
                ),
                const SizedBox(width: 4),
                MindUserAvatar(
                  avatarId: avatarUrl,
                  size: 34,
                  onTap: onProfileTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

