import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Cabecera serena de la pantalla de Gamificación Detallada acorde al diseño de Figma.
class ProgressHeader extends StatelessWidget implements PreferredSizeWidget {
  const ProgressHeader({
    super.key,
    required this.onBack,
    this.onProfile,
  });

  final VoidCallback onBack;
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
              onTap: onProfile,
              child: Container(
                width: 36,
                height: 36,
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
      ),
    );
  }
}

