import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Insignia de "ESPACIO SAGRADO", título "Mi Diario Personal" y banner de cifrado local (Principio V).
class JournalPrivacyBanner extends StatelessWidget {
  const JournalPrivacyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Insignia "ESPACIO SAGRADO"
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MindColors.estudioTrabajo,
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 15,
                color: MindColors.estudioTrabajoAccent,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'ESPACIO SAGRADO',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: MindColors.estudioTrabajoAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Título principal
        const Text(
          'Mi Diario Personal',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: MindColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Banner de cifrado y privacidad local
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: MindColors.surfaceSubtle.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: MindColors.primaryLight.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lock_rounded,
                size: 16,
                color: MindColors.primaryDark,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Un espacio solo para ti. Tus pensamientos están protegidos y cifrados en tu dispositivo 🔒',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

