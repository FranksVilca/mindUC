import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/community_avatar.dart';
import '../../domain/entities/community_mood_category.dart';
import '../../domain/services/community_content_moderator.dart';

class _AliasOption {
  final String alias;
  final String role;
  final CommunityAvatar avatar;

  const _AliasOption({
    required this.alias,
    required this.role,
    required this.avatar,
  });
}

const List<_AliasOption> _defaultAliases = [
  _AliasOption(
    alias: '@BúhoCurioso',
    role: 'Búho Sereno',
    avatar: CommunityAvatar.moon,
  ),
  _AliasOption(
    alias: '@BroteCalmo',
    role: 'Brote Verde',
    avatar: CommunityAvatar.sprout,
  ),
  _AliasOption(
    alias: '@LluviaSuave',
    role: 'Brizna Serena',
    avatar: CommunityAvatar.raindrop,
  ),
  _AliasOption(
    alias: '@EstrellaSerena',
    role: 'Luz Cálida',
    avatar: CommunityAvatar.flower,
  ),
  _AliasOption(
    alias: '@RobleSabio',
    role: 'Guardián Calmo',
    avatar: CommunityAvatar.sprout,
  ),
  _AliasOption(
    alias: '@CantoSuave',
    role: 'Brizna Armoniosa',
    avatar: CommunityAvatar.moon,
  ),
];

const List<String> _faculties = [
  'Ingeniería',
  'Medicina',
  'Humanidades',
  'Ciencias Sociales',
  'Derecho',
  'Arquitectura',
  'Ciencias Biológicas',
  'Educación',
  'Comunidad UC',
];

/// Modal sereno para compartir una reflexión anónima con identidad efímera protegida (Principio V).
class CommunityPostCreateModal extends StatefulWidget {
  const CommunityPostCreateModal({
    super.key,
    required this.onPublish,
  });

  final void Function(
    String authorAlias,
    String authorRole,
    CommunityAvatar avatar,
    String faculty,
    String content,
    List<String> tags,
    CommunityMoodCategory moodCategory,
  ) onPublish;

  static Future<void> show(
    BuildContext context, {
    required void Function(
      String authorAlias,
      String authorRole,
      CommunityAvatar avatar,
      String faculty,
      String content,
      List<String> tags,
      CommunityMoodCategory moodCategory,
    ) onPublish,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CommunityPostCreateModal(onPublish: onPublish),
    );
  }

  @override
  State<CommunityPostCreateModal> createState() =>
      _CommunityPostCreateModalState();
}

class _CommunityPostCreateModalState extends State<CommunityPostCreateModal> {
  late final TextEditingController _textController;
  late _AliasOption _currentAlias;
  late String _selectedFaculty;
  late CommunityMoodCategory _selectedMood;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _currentAlias = _defaultAliases[Random().nextInt(_defaultAliases.length)];
    _selectedFaculty = _faculties.first;
    _selectedMood = CommunityMoodCategory.estresAcademico;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _regenerateAlias() {
    setState(() {
      final filtered = _defaultAliases
          .where((a) => a.alias != _currentAlias.alias)
          .toList();
      _currentAlias = filtered[Random().nextInt(filtered.length)];
    });
  }

  void _handlePublish() {
    final text = _textController.text.trim();

    // Validación mediante el moderador de contenidos (Privacidad y Convivencia)
    final moderation = CommunityContentModerator.validate(text);
    if (!moderation.isValid) {
      setState(() {
        _errorMessage = moderation.message;
      });
      return;
    }

    final tags = <String>['• ${_selectedMood.displayName}'];

    widget.onPublish(
      _currentAlias.alias,
      _currentAlias.role,
      _currentAlias.avatar,
      _selectedFaculty,
      text,
      tags,
      _selectedMood,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardBottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: MindColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 20 + keyboardBottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Asa de arrastre superior
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: MindColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Título de la hoja y botón de cierre
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Compartir reflexión anónima',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: MindColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: MindColors.textSecondary,
                  ),
                  splashRadius: 20,
                  tooltip: 'Cerrar',
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Identidad efímera asignada (Principio V)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4EFE6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5DFD3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _currentAlias.avatar.backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _currentAlias.avatar.icon,
                      color: _currentAlias.avatar.iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _currentAlias.alias,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: MindColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                '(${_currentAlias.role})',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5D8572),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Identidad protegida y efímera 🛡',
                          style: TextStyle(
                            fontSize: 11,
                            color: MindColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _regenerateAlias,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 20,
                      color: MindColors.textSecondary,
                    ),
                    tooltip: 'Cambiar alias ficticio',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Selector de Facultad
            const Text(
              'Facultad / Escuela',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: MindColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F7F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MindColors.divider),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFaculty,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: MindColors.textSecondary,
                  ),
                  items: _faculties.map((f) {
                    return DropdownMenuItem<String>(
                      value: f,
                      child: Text(
                        f,
                        style: const TextStyle(
                          fontSize: 13,
                          color: MindColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedFaculty = val);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Selector de Sentir / Categoría
            const Text(
              '¿Qué sentir describe tu reflexión?',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: MindColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: CommunityMoodCategory.values
                  .where((c) => c != CommunityMoodCategory.todo)
                  .map((category) {
                final isSelected = _selectedMood == category;
                return ChoiceChip(
                  label: Text(
                    category.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color:
                          isSelected ? Colors.white : MindColors.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF3F5E4D),
                  backgroundColor: MindColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF3F5E4D)
                          : MindColors.divider,
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedMood = category);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Campo de texto reflexivo
            const Text(
              'Tu mensaje para la comunidad',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: MindColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _textController,
              minLines: 3,
              maxLines: 6,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
              decoration: InputDecoration(
                hintText:
                    'Comparte tu sentir, reflexión o vivencia con la comunidad... Recuerda que este es un espacio seguro y empático 🤍',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: MindColors.textTertiary,
                ),
                filled: true,
                fillColor: const Color(0xFFF9F7F2),
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: MindColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: MindColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF3F5E4D),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            // Mensaje de error / advertencia de privacidad
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD66853),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Botón de publicación
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _handlePublish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F5E4D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Publicar en comunidad',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
