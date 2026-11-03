import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Cabecera de la pestaña "Mi Agenda consciente" acorde al diseño de Figma.
class AgendaHeader extends StatelessWidget {
  const AgendaHeader({
    super.key,
    this.onNotification,
    this.onProfile,
  });

  final VoidCallback? onNotification;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Espacio compensatorio a la izquierda
          const SizedBox(width: 44),

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
                    onPressed: onNotification ?? () {},
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
              GestureDetector(
                onTap: onProfile,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B5648),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

