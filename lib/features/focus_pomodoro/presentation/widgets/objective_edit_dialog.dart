import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Diálogo accesible para actualizar el objetivo académico en curso.
class ObjectiveEditDialog extends StatefulWidget {
  const ObjectiveEditDialog({
    super.key,
    required this.initialObjective,
    required this.onSave,
  });

  final String initialObjective;
  final ValueChanged<String> onSave;

  /// Método estático de conveniencia para desplegar el diálogo.
  static Future<void> show(
    BuildContext context, {
    required String initialObjective,
    required ValueChanged<String> onSave,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => ObjectiveEditDialog(
        initialObjective: initialObjective,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ObjectiveEditDialog> createState() => _ObjectiveEditDialogState();
}

class _ObjectiveEditDialogState extends State<ObjectiveEditDialog> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialObjective);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSave(text);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: const Row(
        children: [
          Icon(Icons.edit_note_rounded, color: MindColors.primary, size: 24),
          SizedBox(width: 8),
          Text(
            'Objetivo de Estudio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: MindColors.textPrimary,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿En qué tarea enfocarás tu atención durante este bloque?',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _textController,
            autofocus: true,
            maxLines: 2,
            maxLength: 80,
            decoration: InputDecoration(
              hintText: 'Ej. Lectura Cap. 4 — Psicología Social',
              filled: true,
              fillColor: MindColors.surfaceSubtle.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: MindColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 16, left: 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: MindColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: MindColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          ),
          child: const Text(
            'Guardar',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
