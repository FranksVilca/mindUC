import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Modal selector de emojis para reaccionar a publicaciones en el foro comunitario.
class EmojiPickerModal extends StatefulWidget {
  const EmojiPickerModal({
    super.key,
    required this.onEmojiSelected,
  });

  final ValueChanged<String> onEmojiSelected;

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String> onEmojiSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: EmojiPickerModal(onEmojiSelected: onEmojiSelected),
      ),
    );
  }

  @override
  State<EmojiPickerModal> createState() => _EmojiPickerModalState();
}

class _EmojiPickerModalState extends State<EmojiPickerModal> {
  final TextEditingController _customEmojiController = TextEditingController();

  static const List<Map<String, dynamic>> _emojiCategories = [
    {
      'title': '🌿 Bienestar y Apoyo',
      'emojis': ['🤍', '❤️', '🌿', '💡', '🫂', '✨', '🌻', '🌱', '🌸', '🧘', '🕊️', '🌊'],
    },
    {
      'title': '💛 Afecto y Calma',
      'emojis': ['😊', '🥰', '😌', '🥺', '🤗', '🫶', '🙌', '👏', '💪', '☀️'],
    },
    {
      'title': '☕ Vida Universitaria',
      'emojis': ['☕', '📚', '🎓', '🔥', '⭐', '🌈', '🎯', '🧠', '😴', '⚡'],
    },
  ];

  @override
  void dispose() {
    _customEmojiController.dispose();
    super.dispose();
  }

  void _submitCustomEmoji() {
    final text = _customEmojiController.text.trim();
    if (text.isNotEmpty) {
      // Tomamos el primer caracter/grafema del emoji ingresado
      final emoji = text.characters.first;
      Navigator.of(context).pop();
      widget.onEmojiSelected(emoji);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador de arrastre superior
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Elige tu reacción con emoji',
                  style: TextStyle(
                    fontSize: 16,
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
            const SizedBox(height: 10),

            // Campo para escribir o pegar cualquier emoji
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customEmojiController,
                    decoration: InputDecoration(
                      hintText: 'O escribe cualquier emoji de tu teclado...',
                      hintStyle: const TextStyle(fontSize: 12.5),
                      filled: true,
                      fillColor: MindColors.surfaceSubtle.withValues(alpha: 0.5),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    onSubmitted: (_) => _submitCustomEmoji(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submitCustomEmoji,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MindColors.primaryDark,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Reaccionar'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Secciones de emojis organizados
            for (final category in _emojiCategories) ...[
              Text(
                category['title'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MindColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (category['emojis'] as List<String>).map((emoji) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.onEmojiSelected(emoji);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F5F0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFEBE6DF),
                          width: 0.8,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}
