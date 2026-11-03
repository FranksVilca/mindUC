import 'package:flutter/material.dart';
import '../../theme/mind_colors.dart';
import '../../theme/mind_typography.dart';

/// Barra superior contextual oficial de mindUC presente en todas las vistas del shell.
class MindAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const MindAppBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.onProfileTap,
    this.showBackButton = false,
    this.onBackTap,
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
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                color: MindColors.textPrimary,
                onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
              )
            else
              const SizedBox(width: 40),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'mindUC',
                  style: MindTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: MindColors.primaryDark,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  title,
                  style: MindTypography.labelSmall.copyWith(
                    color: MindColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
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
                  onPressed: onNotificationTap ?? () {},
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onProfileTap ?? () {},
                  child: const CircleAvatar(
                    radius: 17,
                    backgroundColor: MindColors.primaryDark,
                    child: Icon(Icons.person, size: 20, color: Colors.white),
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
