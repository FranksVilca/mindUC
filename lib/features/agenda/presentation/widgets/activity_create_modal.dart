import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/agenda_category.dart';

/// Modal para planificar y registrar una nueva actividad en la agenda consciente.
class ActivityCreateModal extends StatefulWidget {
  const ActivityCreateModal({
    super.key,
    required this.defaultDate,
    required this.onSave,
  });

  final DateTime defaultDate;
  final void Function(
    String title,
    String subtitle,
    DateTime scheduledDateTime,
    AgendaCategory category,
  ) onSave;

  /// Muestra el modal como una hoja inferior (bottom sheet)
  static Future<void> show(
    BuildContext context, {
    required DateTime defaultDate,
    required void Function(
      String title,
      String subtitle,
      DateTime scheduledDateTime,
      AgendaCategory category,
    ) onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ActivityCreateModal(
          defaultDate: defaultDate,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<ActivityCreateModal> createState() => _ActivityCreateModalState();
}

class _ActivityCreateModalState extends State<ActivityCreateModal> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late AgendaCategory _selectedCategory;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    _selectedCategory = AgendaCategory.autocuidado;
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    final subtitle = _subtitleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor escribe un título para tu actividad.'),
          duration: Duration(seconds: 2),
          backgroundColor: MindColors.primaryDark,
        ),
      );
      return;
    }

    final scheduled = DateTime(
      widget.defaultDate.year,
      widget.defaultDate.month,
      widget.defaultDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    widget.onSave(title, subtitle, scheduled, _selectedCategory);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.hour < 12 ? 'AM' : 'PM'}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nueva actividad consciente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MindColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  splashRadius: 20,
                  tooltip: 'Cerrar',
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Selector de Categoría
            const Text(
              'Categoría de balance',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AgendaCategory.values.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _selectedCategory = cat),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cat.backgroundColor
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? cat.accentColor
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          cat.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? cat.accentColor
                                : MindColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Título
            const Text(
              'Título',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '¿Qué actividad consciente deseas planificar?',
                filled: true,
                fillColor: MindColors.surfaceSubtle.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: MindColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Campo de Subtítulo / Nota
            const Text(
              'Descripción o nota (opcional)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _subtitleController,
              decoration: InputDecoration(
                hintText: 'Detalles breves o recordatorio amable...',
                filled: true,
                fillColor: MindColors.surfaceSubtle.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: MindColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Selector de Horario
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Horario programado',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: MindColors.textSecondary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null) {
                      setState(() => _selectedTime = picked);
                    }
                  },
                  icon: const Icon(Icons.access_time_rounded, size: 18),
                  label: Text(timeStr),
                  style: TextButton.styleFrom(
                    foregroundColor: MindColors.primaryDark,
                    backgroundColor: MindColors.surfaceSubtle,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botón de Guardado
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MindColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Guardar actividad',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

