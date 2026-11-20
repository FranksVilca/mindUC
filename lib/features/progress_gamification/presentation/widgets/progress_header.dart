import 'package:flutter/material.dart';
import '../../../../core/design_system/avatars/mind_user_avatar.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/theme/mind_colors.dart';

/// Cabecera serena de la pantalla de Gamificación Detallada acorde al diseño de Figma.
class ProgressHeader extends StatelessWidget implements PreferredSizeWidget {
  const ProgressHeader({
    super.key,
    required this.onBack,
    this.onProfile,
    this.avatarUrl,
  });

  final VoidCallback onBack;
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
                  key: const Key('progress_header_back_btn'),
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
                  'MINDUC',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: MindColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Gamificación Detallada',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: MindColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            GestureDetector(
              key: const Key('progress_header_profile_btn'),
              onTap: onProfile,
              child: MindUserAvatar(
                avatarId: avatarUrl,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

