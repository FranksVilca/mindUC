import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Tarjeta de bienvenida y espacio seguro de la Comunidad UC consciente.
/// Refleja las insignias "ESPACIO SEGURO UC", "Moderado con empatía" y el aviso de identidad protegida (Principio V).
class CommunityBannerCard extends StatelessWidget {
  const CommunityBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MindColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MindColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Insignias superiores: ESPACIO SEGURO UC & Moderado con empatía
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEAD9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ESPACIO SEGURO UC',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C4C3B),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5D8572),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Moderado con empatía',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: MindColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Título principal
          const Text(
            'Comunidad UC Consciente',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: MindColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),

          // Descripción compasiva
          const Text(
            'Un espacio anónimo, seguro y libre de juicios para compartir tus vivencias, desahogarte y encontrar apoyo entre pares.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: MindColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),

          // Caja informativa de identidad protegida
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EFE6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2D9C8),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: Color(0xFF5D8572),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Identidad protegida: todos los alias son ficticios y efímeros.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3F5E4D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
