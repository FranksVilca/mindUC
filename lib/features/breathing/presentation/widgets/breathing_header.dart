import 'package:flutter/material.dart';
import 'package:minduc/core/theme/mind_colors.dart';

/// Barra de navegación superior serena según mockup de Figma:
/// Botón de retroceso, título centrado "Sesion Respiracion", subtítulo "mindUC",
/// campana de notificaciones y avatar del usuario.
class BreathingHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;

  const BreathingHeader({
    super.key,
    this.onBack,
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
            // 1. Botón de retroceso
            Material(
              color: Colors.white,
              shape: const CircleBorder(
                side: BorderSide(color: MindColors.divider, width: 1),
              ),
              child: InkWell(
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

            // 3. Campana de notificaciones y avatar
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    size: 22,
                    color: MindColors.textPrimary,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                const SizedBox(width: 4),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: MindColors.autocuidado,
                  child: Icon(
                    Icons.person,
                    size: 18,
                    color: MindColors.primaryDark,
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
