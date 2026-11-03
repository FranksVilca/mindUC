import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Tarjeta del Modo Enfoque Profundo consciente que promueve la autorregulación
/// y el compromiso de distracción cero (Principio VII de la Constitución de mindUC).
class DeepFocusCard extends StatelessWidget {
  const DeepFocusCard({
    super.key,
    required this.isEnabled,
    required this.onToggle,
    this.onLearnMore,
  });

  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onLearnMore;

  void _showPrincipleInfo(BuildContext context) {
    if (onLearnMore != null) {
      onLearnMore!();
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.shield_rounded, color: MindColors.primary, size: 24),
            SizedBox(width: 8),
            Text(
              'Enfoque Consciente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: MindColors.textPrimary,
              ),
            ),
          ],
        ),
        content: const Text(
          'mindUC promueve la concentración mediante la autorregulación y el autocuidado consciente.\n\n'
          'Las aplicaciones de distracción se silencian simbólicamente como un pacto personal de estudio, '
          'evitando bloqueos restrictivos a nivel de sistema operativo conforme al Principio VII de nuestra Constitución.',
          style: TextStyle(
            fontSize: 13,
            height: 1.45,
            color: MindColors.textSecondary,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: MindColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Comprendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icono de escudo
              GestureDetector(
                onTap: () => _showPrincipleInfo(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MindColors.bienestarPill,
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    color: MindColors.primaryDark,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Textos descriptivos
              Expanded(
                child: GestureDetector(
                  onTap: () => _showPrincipleInfo(context),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Modo enfoque profundo',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: MindColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '3 apps silenciadas temporalmente',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Interruptor
              Switch.adaptive(
                value: isEnabled,
                onChanged: onToggle,
                activeThumbColor: MindColors.primary,
                activeTrackColor: const Color(0xFFB5CFB7),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Fila de chips de apps bloqueadas simbólicamente
          const Row(
            children: [
              _AppLockChip(
                dotColor: Color(0xFFE53935),
                appName: 'Instagram',
              ),
              SizedBox(width: 8),
              _AppLockChip(
                dotColor: Color(0xFF7E57C2),
                appName: 'TikTok',
              ),
              SizedBox(width: 8),
              _AppLockChip(
                dotColor: Color(0xFF43A047),
                appName: 'WhatsApp',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppLockChip extends StatelessWidget {
  const _AppLockChip({
    required this.dotColor,
    required this.appName,
  });

  final Color dotColor;
  final String appName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$appName 🔒',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: MindColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

