import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../theme/mind_colors.dart';

/// Modal sereno tipo bandeja de notificaciones para mindUC.
/// Muestra las alertas activas, recordatorios de agenda y pausas de bienestar.
class NotificationTrayModal extends StatefulWidget {
  const NotificationTrayModal({super.key});

  /// Muestra el modal en la parte inferior de la pantalla
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationTrayModal(),
    );
  }

  @override
  State<NotificationTrayModal> createState() => _NotificationTrayModalState();
}

class _NotificationTrayModalState extends State<NotificationTrayModal> {
  final NotificationService _service = NotificationService.instance;

  @override
  Widget build(BuildContext context) {
    final items = _service.history;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Asa superior
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cabecera del modal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: Color(0xFF2E6347),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Notificaciones',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: MindColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (items.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _service.clearHistory();
                        });
                      },
                      child: const Text(
                        'Limpiar',
                        style: TextStyle(
                          fontSize: 13,
                          color: MindColors.textSecondary,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Botón de prueba rápida
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    '¿Deseas probar una alerta en tu móvil?',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: MindColors.textPrimary,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await _service.requestPermission();
                    await _service.showNotification(
                      id: 9999,
                      title: '¡Pausa de prueba en mindUC! 🌿',
                      body: 'Tus notificaciones locales están funcionando correctamente en tu teléfono.',
                    );
                    if (context.mounted) {
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 14),
                  label: const Text(
                    'Probar',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2E6347),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Lista de notificaciones o estado vacío
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF4EFE6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF718E81),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'No tienes notificaciones pendientes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: MindColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tus recordatorios de agenda y pausas conscientes aparecerán aquí.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: MindColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _NotificationRow(
                    key: ValueKey(item.id),
                    item: item,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final AppNotificationItem item;

  const _NotificationRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconBg;
    Color iconColor;

    switch (item.category) {
      case 'pomodoro':
        icon = Icons.timer_outlined;
        iconBg = const Color(0xFFEBE8F7);
        iconColor = const Color(0xFF6B62A8);
        break;
      case 'agenda':
        icon = Icons.event_note_rounded;
        iconBg = const Color(0xFFE8F2EC);
        iconColor = const Color(0xFF2E6347);
        break;
      default:
        icon = Icons.spa_outlined;
        iconBg = const Color(0xFFFCE7E1);
        iconColor = const Color(0xFFC76454);
    }

    final timeStr =
        '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: MindColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: MindColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.body,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MindColors.textSecondary,
                    height: 1.3,
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
