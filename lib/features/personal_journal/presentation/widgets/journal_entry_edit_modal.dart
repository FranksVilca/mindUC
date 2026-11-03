import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_mood_pulse.dart';

/// Modal interactivo para redactar una nueva reflexión o editar una existente.
class JournalEntryEditModal extends StatefulWidget {
  const JournalEntryEditModal({
    super.key,
    this.existingEntry,
    required this.defaultPulse,
    required this.onSave,
  });

  final JournalEntry? existingEntry;
  final JournalMoodPulse defaultPulse;
  final void Function(String title, String content, JournalMoodPulse pulse) onSave;

  /// Método estático para desplegar el modal como una hoja inferior (bottom sheet).
  static Future<void> show(
    BuildContext context, {
    JournalEntry? existingEntry,
    required JournalMoodPulse defaultPulse,
    required void Function(String title, String content, JournalMoodPulse pulse)
        onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: JournalEntryEditModal(
          existingEntry: existingEntry,
          defaultPulse: defaultPulse,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<JournalEntryEditModal> createState() => _JournalEntryEditModalState();
}

class _JournalEntryEditModalState extends State<JournalEntryEditModal> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late JournalMoodPulse _selectedPulse;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingEntry?.title ?? '');
    _contentController =
        TextEditingController(text: widget.existingEntry?.content ?? '');
    _selectedPulse = widget.existingEntry?.moodPulse ?? widget.defaultPulse;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa el título y tu reflexión.'),
          duration: Duration(seconds: 2),
          backgroundColor: MindColors.primaryDark,
        ),
      );
      return;
    }

    widget.onSave(title, content, _selectedPulse);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingEntry != null;

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
            // Cabecera del modal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Editar reflexión' : 'Nueva entrada reflexiva',
                  style: const TextStyle(
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

            // Selector horizontal de estado emocional
            const Text(
              '¿Cómo te sientes en este instante?',
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
                children: JournalMoodPulse.values.map((pulse) {
                  final isSelected = pulse == _selectedPulse;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(pulse.chipText),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _selectedPulse = pulse);
                      },
                      selectedColor: MindColors.bienestarPill,
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? MindColors.primaryDark
                            : MindColors.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected
                              ? MindColors.primary
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de título
            TextField(
              controller: _titleController,
              maxLength: 80,
              decoration: InputDecoration(
                hintText: 'Título de tu reflexión (ej. Soltar lo que no controlo)',
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
            const SizedBox(height: 8),

            // Campo de contenido
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    'Plasma tus pensamientos con total libertad, intimidad y sin juicio...',
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
            const SizedBox(height: 16),

            // Botón de guardado
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
                child: Text(
                  isEditing ? 'Guardar cambios' : 'Guardar reflexión',
                  style: const TextStyle(
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

