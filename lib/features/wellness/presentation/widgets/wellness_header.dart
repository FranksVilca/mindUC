import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Barra de navegación superior serena para el Hub de Bienestar según mockup de Figma:
/// Título centrado "mindUC / Bienestar", campana con punto de aviso y avatar circular.
class WellnessHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const WellnessHeader({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Espacio simétrico a la izquierda para centrar el título
            const SizedBox(width: 64),

            // 1. Título centrado y subtítulo sereno
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'mindUC',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MindColors.primaryDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Bienestar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MindColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Campana de notificaciones con punto y avatar
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        size: 24,
                        color: MindColors.textPrimary,
                      ),
                      onPressed: onNotificationTap ?? () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7B72B8), // Punto sutil lavanda de aviso
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onProfileTap ?? () {},
                  child: const CircleAvatar(
                    radius: 17,
                    backgroundColor: MindColors.primaryDark,
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.white,
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
