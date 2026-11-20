import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/app_blocker_status.dart';
import '../../domain/entities/blocked_app.dart';

/// Tarjeta del Modo Enfoque Profundo que gestiona el bloqueo de aplicaciones distractoras,
/// muestra el estado de permisos y permite seleccionar qué aplicaciones silenciar
/// mediante el botón "Seleccionar" que despliega el modal configurador.
class DeepFocusCard extends StatefulWidget {
  const DeepFocusCard({
    super.key,
    required this.isEnabled,
    required this.onToggle,
    this.status = BlockerPermissionStatus.inactive,
    this.blockedApps,
    this.availableApps,
    this.blockingDurationMinutes = 25,
    this.onSelectApps,
    this.onToggleApp,
    this.onRemoveApp,
    this.onRequestPermissions,
    this.onLearnMore,
  });

  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final BlockerPermissionStatus status;
  final List<BlockedApp>? blockedApps;
  final List<BlockedApp>? availableApps;
  final int blockingDurationMinutes;
  final VoidCallback? onSelectApps;
  final void Function(String appId, bool isBlocked)? onToggleApp;
  final ValueChanged<String>? onRemoveApp;
  final VoidCallback? onRequestPermissions;
  final VoidCallback? onLearnMore;

  @override
  State<DeepFocusCard> createState() => _DeepFocusCardState();
}

class _DeepFocusCardState extends State<DeepFocusCard> {
  void _showPrincipleInfo(BuildContext context) {
    if (widget.onLearnMore != null) {
      widget.onLearnMore!();
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
          'Las aplicaciones seleccionadas se silencian y restringen conforme a los permisos otorgados en tu dispositivo, '
          'respetando la transparencia técnica del Principio VII de nuestra Constitución.',
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

  Color _statusColor() {
    if (!widget.isEnabled) return Colors.grey.shade600;
    switch (widget.status) {
      case BlockerPermissionStatus.active:
        return MindColors.primaryDark;
      case BlockerPermissionStatus.pendingPermissions:
        return const Color(0xFFE65100);
      case BlockerPermissionStatus.webRestricted:
        return const Color(0xFF1565C0);
      case BlockerPermissionStatus.inactive:
        return Colors.grey.shade600;
    }
  }

  Color _statusBg() {
    if (!widget.isEnabled) return Colors.grey.shade100;
    switch (widget.status) {
      case BlockerPermissionStatus.active:
        return const Color(0xFFE2F0E7);
      case BlockerPermissionStatus.pendingPermissions:
        return const Color(0xFFFFF3E0);
      case BlockerPermissionStatus.webRestricted:
        return const Color(0xFFE3F2FD);
      case BlockerPermissionStatus.inactive:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveApps = (widget.blockedApps != null && widget.blockedApps!.isNotEmpty)
        ? widget.blockedApps!
        : BlockedApp.defaultApps.take(3).toList();

    final count = effectiveApps.length;
    final subtitleText = '$count apps silenciadas temporalmente';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icono de escudo interactivo
              GestureDetector(
                onTap: () => _showPrincipleInfo(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _statusBg(),
                  ),
                  child: Icon(
                    Icons.shield_rounded,
                    color: _statusColor(),
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
                        subtitleText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Interruptor maestro
              Switch.adaptive(
                value: widget.isEnabled,
                onChanged: widget.onToggle,
                activeThumbColor: MindColors.primary,
                activeTrackColor: const Color(0xFFB5CFB7),
              ),
            ],
          ),

          // Aviso de permisos si están pendientes
          if (widget.isEnabled && widget.status == BlockerPermissionStatus.pendingPermissions) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFB74D)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFE65100)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Faltan permisos para pausar apps automáticamente.',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFFBF360C)),
                    ),
                  ),
                  if (widget.onRequestPermissions != null)
                    TextButton(
                      onPressed: widget.onRequestPermissions,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('Conceder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                ],
              ),
            ),
          ],

          // Aviso si es web o plataforma restringida
          if (widget.isEnabled && widget.status == BlockerPermissionStatus.webRestricted) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.laptop_chromebook_rounded, size: 16, color: Color(0xFF1565C0)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Modo autorregulación consciente (bloqueo simbólico).',
                      style: TextStyle(fontSize: 11, color: Color(0xFF0D47A1)),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Cabecera de apps bloqueadas y botón Seleccionar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Aplicaciones bloqueadas',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MindColors.textSecondary,
                  ),
                ),
              ),
              if (widget.onSelectApps != null)
                InkWell(
                  key: const Key('deep_focus_select_apps_button'),
                  onTap: widget.onSelectApps,
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune_rounded, size: 14, color: MindColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Seleccionar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: MindColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Fila de chips de apps bloqueadas
          if (effectiveApps.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'No has seleccionado aplicaciones para silenciar. Toca "Seleccionar".',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: effectiveApps.map((app) {
                return _AppLockChip(
                  dotColor: app.dotColor,
                  appName: app.name.contains('🔒') ? app.name : '${app.name} 🔒',
                  onRemove: widget.onRemoveApp != null ? () => widget.onRemoveApp!(app.id) : null,
                );
              }).toList(),
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
    this.onRemove,
  });

  final Color dotColor;
  final String appName;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2EBE2),
        ),
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
            appName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: MindColors.textPrimary,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(
                Icons.close_rounded,
                size: 13,
                color: MindColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
