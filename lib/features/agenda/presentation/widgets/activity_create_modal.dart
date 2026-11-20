import 'package:flutter/material.dart';
import '../../../../core/services/voice/speech_recognition_service.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/agenda_activity.dart';
import '../../domain/entities/agenda_category.dart';
import 'voice_assistant_modal.dart';

typedef ActivitySaveCallback = void Function(
  String title,
  String subtitle,
  DateTime scheduledDateTime,
  AgendaCategory category,
  int? reminderMinutesBefore,
  List<int> reminderMinutesList,
);

typedef ActivityUpdateCallback = void Function(
  String id,
  String title,
  String subtitle,
  DateTime scheduledDateTime,
  AgendaCategory category,
  int? reminderMinutesBefore,
  List<int> reminderMinutesList,
);

/// Modal para planificar, registrar y editar una actividad en la agenda consciente.
class ActivityCreateModal extends StatefulWidget {
  const ActivityCreateModal({
    super.key,
    required this.defaultDate,
    required this.onSave,
    this.activityToEdit,
    this.initialTitle,
    this.initialSubtitle,
    this.initialCategory,
    this.initialTime,
    this.onUpdate,
    this.onDelete,
    this.speechService,
  });

  final DateTime defaultDate;
  final AgendaActivity? activityToEdit;
  final String? initialTitle;
  final String? initialSubtitle;
  final AgendaCategory? initialCategory;
  final TimeOfDay? initialTime;
  final ActivitySaveCallback onSave;
  final ActivityUpdateCallback? onUpdate;
  final void Function(String id)? onDelete;
  final SpeechRecognitionService? speechService;

  bool get isEditing => activityToEdit != null;

  /// Muestra el modal para crear o editar como una hoja inferior (bottom sheet)
  static Future<void> show(
    BuildContext context, {
    required DateTime defaultDate,
    AgendaActivity? activityToEdit,
    String? initialTitle,
    String? initialSubtitle,
    AgendaCategory? initialCategory,
    TimeOfDay? initialTime,
    required ActivitySaveCallback onSave,
    ActivityUpdateCallback? onUpdate,
    void Function(String id)? onDelete,
    SpeechRecognitionService? speechService,
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
          activityToEdit: activityToEdit,
          initialTitle: initialTitle,
          initialSubtitle: initialSubtitle,
          initialCategory: initialCategory,
          initialTime: initialTime,
          onSave: onSave,
          onUpdate: onUpdate,
          onDelete: onDelete,
          speechService: speechService,
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
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late Set<int> _selectedReminderMinutesSet;

  static const List<Map<String, dynamic>> _reminderOptions = [
    {
      'minutes': 1440,
      'label': '1 día antes',
      'icon': Icons.alarm_rounded,
    },
    {
      'minutes': 120,
      'label': '2 horas antes',
      'icon': Icons.hourglass_bottom_rounded,
    },
    {
      'minutes': 30,
      'label': 'Media hora antes',
      'icon': Icons.schedule_rounded,
    },
    {
      'minutes': 15,
      'label': '15 min antes',
      'icon': Icons.timer_outlined,
    },
    {
      'minutes': 10,
      'label': '10 min antes',
      'icon': Icons.timer_outlined,
    },
    {
      'minutes': 5,
      'label': '5 min antes',
      'icon': Icons.notifications_active_outlined,
    },
    {
      'minutes': 0,
      'label': 'A la hora del evento',
      'icon': Icons.notifications_active_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    final edit = widget.activityToEdit;

    _titleController = TextEditingController(
      text: edit?.title ?? widget.initialTitle ?? '',
    );
    _subtitleController = TextEditingController(
      text: edit?.subtitle ?? widget.initialSubtitle ?? '',
    );
    _selectedCategory = edit?.category ??
        widget.initialCategory ??
        AgendaCategory.autocuidado;

    if (edit != null) {
      if (edit.reminderMinutesList.isNotEmpty) {
        _selectedReminderMinutesSet = Set<int>.from(edit.reminderMinutesList);
      } else if (edit.reminderMinutesBefore != null) {
        _selectedReminderMinutesSet = {edit.reminderMinutesBefore!};
      } else {
        _selectedReminderMinutesSet = {0};
      }
    } else {
      _selectedReminderMinutesSet = {0};
    }

    _selectedDate = edit != null
        ? DateTime(
            edit.scheduledDateTime.year,
            edit.scheduledDateTime.month,
            edit.scheduledDateTime.day,
          )
        : DateTime(
            widget.defaultDate.year,
            widget.defaultDate.month,
            widget.defaultDate.day,
          );

    _selectedTime = edit != null
        ? TimeOfDay(
            hour: edit.scheduledDateTime.hour,
            minute: edit.scheduledDateTime.minute,
          )
        : (widget.initialTime ?? TimeOfDay.now());
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
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final reminderList = _selectedReminderMinutesSet.toList()
      ..sort((a, b) => b.compareTo(a));
    final singleReminder = reminderList.firstOrNull;

    if (widget.isEditing && widget.onUpdate != null) {
      widget.onUpdate!(
        widget.activityToEdit!.id,
        title,
        subtitle,
        scheduled,
        _selectedCategory,
        singleReminder,
        reminderList,
      );
    } else {
      widget.onSave(
        title,
        subtitle,
        scheduled,
        _selectedCategory,
        singleReminder,
        reminderList,
      );
    }

    Navigator.of(context).pop();
  }

  void _openVoiceAssistant() {
    if (widget.speechService == null) return;
    VoiceAssistantModal.show(
      context,
      speechService: widget.speechService!,
      referenceDate: _selectedDate,
      onActivityParsed: (parsed) {
        setState(() {
          _titleController.text = parsed.title;
          if (parsed.subtitle.isNotEmpty) {
            _subtitleController.text = parsed.subtitle;
          }
          _selectedCategory = parsed.category;
          _selectedDate = parsed.scheduledDate;
          _selectedTime = parsed.scheduledTime;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.hour < 12 ? 'AM' : 'PM'}';
    final dateStr = SpanishDateFormatter.format(_selectedDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              children: [
                Expanded(
                  child: Text(
                    widget.isEditing
                        ? 'Editar actividad consciente'
                        : 'Nueva actividad consciente',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: MindColors.textPrimary,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.speechService != null)
                      IconButton(
                        onPressed: _openVoiceAssistant,
                        icon: const Icon(Icons.mic_none_rounded),
                        color: MindColors.primaryDark,
                        splashRadius: 20,
                        tooltip: 'Dictar por voz',
                      ),
                    if (widget.isEditing && widget.onDelete != null)
                      IconButton(
                        onPressed: () {
                          widget.onDelete!(widget.activityToEdit!.id);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.delete_outline_rounded),
                        color: MindColors.error,
                        splashRadius: 20,
                        tooltip: 'Eliminar actividad',
                      ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      splashRadius: 20,
                      tooltip: 'Cerrar',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Selector de Categoría
            const Text(
              'Categoría de balance',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
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
            const SizedBox(height: 10),

            // Campo de Título
            const Text(
              'Título',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            const SizedBox(height: 10),

            // Campo de Subtítulo / Nota
            const Text(
              'Descripción o nota (opcional)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _subtitleController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            const SizedBox(height: 10),

            // Selectores de Fecha y Hora
            Row(
              children: [
                // Selector de Fecha
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fecha programada',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: MindColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: MindColors.primaryDark,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: MindColors.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: MindColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: MindColors.primaryDark,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  dateStr,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MindColors.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Selector de Horario
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Horario programado',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: MindColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: MindColors.primaryDark,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: MindColors.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => _selectedTime = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: MindColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: MindColors.primaryDark,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  timeStr,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MindColors.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Selector de Recordatorio / Aviso Previo
            // Selector de Recordatorio / Avisos Previos (Checkboxes múltiples)
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Avisos y recordatorios (selección múltiple)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MindColors.textSecondary,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _selectedReminderMinutesSet.isNotEmpty
                        ? const Color(0xFFE8F5E9)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedReminderMinutesSet.isNotEmpty
                          ? const Color(0xFFA5D6A7)
                          : Colors.grey.shade300,
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    _selectedReminderMinutesSet.isEmpty
                        ? 'Sin alarmas'
                        : '${_selectedReminderMinutesSet.length} activada${_selectedReminderMinutesSet.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _selectedReminderMinutesSet.isNotEmpty
                          ? const Color(0xFF2E6347)
                          : MindColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final opt in _reminderOptions) ...[
                  Builder(
                    builder: (context) {
                      final int mins = opt['minutes'] as int;
                      final String label = opt['label'] as String;
                      final IconData icon = opt['icon'] as IconData;
                      final bool isChecked =
                          _selectedReminderMinutesSet.contains(mins);

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          key: Key('activity_reminder_checkbox_$mins'),
                          onTap: () {
                            setState(() {
                              if (isChecked) {
                                _selectedReminderMinutesSet.remove(mins);
                              } else {
                                _selectedReminderMinutesSet.add(mins);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? const Color(0xFFE8F5E9)
                                  : MindColors.surfaceSubtle
                                      .withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isChecked
                                    ? MindColors.primaryDark
                                    : Colors.grey.shade300,
                                width: isChecked ? 1.2 : 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    key: Key('checkbox_item_$mins'),
                                    value: isChecked,
                                    activeColor: MindColors.primaryDark,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          _selectedReminderMinutesSet.add(mins);
                                        } else {
                                          _selectedReminderMinutesSet
                                              .remove(mins);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  icon,
                                  size: 14,
                                  color: isChecked
                                      ? MindColors.primaryDark
                                      : MindColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isChecked
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isChecked
                                        ? MindColors.textPrimary
                                        : MindColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // Botón de Guardado / Actualizado
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                key: const Key('activity_save_button'),
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MindColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  widget.isEditing
                      ? 'Actualizar actividad'
                      : 'Guardar actividad',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (widget.isEditing && widget.onDelete != null) ...[
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: OutlinedButton.icon(
                  key: const Key('activity_delete_button'),
                  onPressed: () {
                    widget.onDelete!(widget.activityToEdit!.id);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Color(0xFFC05555),
                  ),
                  label: const Text(
                    'Eliminar actividad',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC05555),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5B4B4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
