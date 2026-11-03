import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Cabecera serena de la Comunidad UC acorde al diseño de Figma.
class CommunityHeader extends StatelessWidget implements PreferredSizeWidget {
  const CommunityHeader({
    super.key,
    required this.onBack,
    this.onNotification,
    this.onProfile,
  });

  final VoidCallback onBack;
  final VoidCallback? onNotification;
  final VoidCallback? onProfile;

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
                      onPressed: onNotification ?? () {},
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
                  onTap: onProfile,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF3F5E4D),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
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
