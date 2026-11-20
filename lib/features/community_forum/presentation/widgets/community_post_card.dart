import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/community_comment.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/embedded_card_data.dart';
import '../../domain/services/community_content_moderator.dart';
import 'emoji_picker_modal.dart';

/// Tarjeta completa de una publicación comunitaria en el foro (Principio V).
/// Renderiza avatar sereno, alias efímero, facultad, tiempo, etiquetas,
/// contenido reflexivo, barra de reacciones con cualquier emoji y sección de comentarios interactiva.
class CommunityPostCard extends StatefulWidget {
  const CommunityPostCard({
    super.key,
    required this.post,
    required this.onReactionTap,
    this.onEmojiReactionTap,
    this.onAddComment,
    this.currentUserId = 'guest_user',
    this.currentUserName = 'Estudiante UC',
    this.onEmbeddedActionTap,
    this.onMenuTap,
  });

  final CommunityPost post;
  final void Function(String reactionKey) onReactionTap;
  final void Function(String emoji)? onEmojiReactionTap;
  final void Function(String content)? onAddComment;
  final String currentUserId;
  final String currentUserName;
  final VoidCallback? onEmbeddedActionTap;
  final VoidCallback? onMenuTap;

  @override
  State<CommunityPostCard> createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  bool _showComments = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final moderation = CommunityContentModerator.validate(text);
    if (!moderation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(moderation.message ?? 'Por favor mantén un lenguaje respetuoso y amable 🤍'),
          backgroundColor: const Color(0xFFD67868),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (widget.onAddComment != null) {
      widget.onAddComment!(text);
      _commentController.clear();
      setState(() {
        _showComments = true;
      });
    }
  }

  void _showCalmOptionsMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: MindColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: MindColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.bookmark_border_rounded,
                    color: MindColors.primaryDark,
                  ),
                  title: const Text(
                    'Guardar reflexión',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reflexión guardada con cariño 🌿'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.favorite_outline_rounded,
                    color: Color(0xFFD67868),
                  ),
                  title: const Text(
                    'Reportar con empatía',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Para cuidar la seguridad y calidez de la comunidad UC',
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Gracias por cuidar a nuestra comunidad 🤍'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MindColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MindColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cabecera del autor efímero y opciones
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar temático
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: post.avatar.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  post.avatar.icon,
                  color: post.avatar.iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),

              // Identidad efímera y rol
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            post.authorAlias,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: MindColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: post.avatar.backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            post.authorRole,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: post.avatar.iconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${post.faculty} · ${post.timeAgo}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: MindColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Menú de opciones compasivas
              IconButton(
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: MindColors.textTertiary,
                  size: 20,
                ),
                splashRadius: 18,
                onPressed: widget.onMenuTap ?? () => _showCalmOptionsMenu(context),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2. Fila de etiquetas conscientes
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: post.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4EFE6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D8572),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // 3. Contenido reflexivo
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 14,
              color: MindColors.textPrimary,
              height: 1.45,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 12),

          // 4. Tarjeta de bienestar incrustada
          _buildEmbeddedCard(context),
          if (post.embeddedCard.type != EmbeddedCardType.none)
            const SizedBox(height: 12),

          // 5. Barra de reacciones con soporte para cualquier emoji y comentarios
          _buildReactionBar(context),

          // 6. Sección de comentarios integrada
          if (_showComments) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: MindColors.divider),
            const SizedBox(height: 12),
            _buildCommentsSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildEmbeddedCard(BuildContext context) {
    final post = widget.post;
    switch (post.embeddedCard.type) {
      case EmbeddedCardType.insightNotice:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD6EADA), width: 1),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.spa_outlined,
                size: 16,
                color: Color(0xFF386B5A),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  post.embeddedCard.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C4C3B),
                  ),
                ),
              ),
            ],
          ),
        );

      case EmbeddedCardType.breathingPrompt:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1ED),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFCEE3D5), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF5D8572),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.air_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.embeddedCard.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C4C3B),
                      ),
                    ),
                    if (post.embeddedCard.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        post.embeddedCard.subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF4C6B5E),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (post.embeddedCard.actionLabel != null &&
                  post.embeddedCard.actionLabel!.isNotEmpty) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: widget.onEmbeddedActionTap,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF2C4C3B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    post.embeddedCard.actionLabel!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );

      case EmbeddedCardType.topReply:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F7F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEBE6DF), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: Color(0xFFD6A461),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    post.embeddedCard.title,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: MindColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (post.embeddedCard.subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  post.embeddedCard.subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontStyle: FontStyle.italic,
                    color: MindColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        );

      case EmbeddedCardType.none:
        return const SizedBox.shrink();
    }
  }

  Widget _buildReactionBar(BuildContext context) {
    final post = widget.post;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Apoyo / Cariño (🤍❤️)
          _buildReactionButton(
            key: 'support',
            emoji: '🤍',
            activeEmoji: '❤️',
            count: post.supportCount,
            isActive: post.hasReaction('support'),
          ),
          const SizedBox(width: 6),

          // Calma (🌿)
          _buildReactionButton(
            key: 'calm',
            emoji: '🌿',
            activeEmoji: '🌿',
            count: post.calmCount,
            isActive: post.hasReaction('calm'),
          ),
          const SizedBox(width: 6),

          // Perspectiva (💡)
          _buildReactionButton(
            key: 'insight',
            emoji: '💡',
            activeEmoji: '💡',
            count: post.insightCount,
            isActive: post.hasReaction('insight'),
          ),
          const SizedBox(width: 6),

          // Abrazo (🫂)
          if (post.hugCount > 0 || post.hasReaction('hug')) ...[
            _buildReactionButton(
              key: 'hug',
              emoji: '🫂',
              activeEmoji: '🫂',
              count: post.hugCount,
              isActive: post.hasReaction('hug'),
            ),
            const SizedBox(width: 6),
          ],

          // Reacciones adicionales de cualquier emoji libre
          for (final entry in post.emojiReactions.entries) ...[
            if (!const ['🤍', '❤️', '🌿', '💡', '🫂'].contains(entry.key) &&
                entry.value.isNotEmpty) ...[
              _buildEmojiPill(
                emoji: entry.key,
                count: entry.value.length,
                isActive: entry.value.contains(widget.currentUserId),
                onTap: () {
                  if (widget.onEmojiReactionTap != null) {
                    widget.onEmojiReactionTap!(entry.key);
                  }
                },
              ),
              const SizedBox(width: 6),
            ],
          ],

          // Botón selector '+' para agregar CUALQUIER emoji
          InkWell(
            onTap: () {
              EmojiPickerModal.show(
                context,
                onEmojiSelected: (emoji) {
                  if (widget.onEmojiReactionTap != null) {
                    widget.onEmojiReactionTap!(emoji);
                  } else {
                    widget.onReactionTap(emoji);
                  }
                },
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F5F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEBE6DF),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 14, color: MindColors.textSecondary),
                  Text('😊', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Comentarios (💬)
          InkWell(
            key: Key('comment_toggle_button_${post.id}'),
            onTap: () {
              setState(() {
                _showComments = !_showComments;
              });
              widget.onReactionTap('comment');
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _showComments
                    ? const Color(0xFFE2F0E7)
                    : const Color(0xFFF7F5F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _showComments
                      ? const Color(0xFF3B5648)
                      : const Color(0xFFEBE6DF),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💬', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text(
                    '${post.totalComments}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          _showComments ? FontWeight.w700 : FontWeight.w600,
                      color: _showComments
                          ? const Color(0xFF2C4C3B)
                          : MindColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionButton({
    required String key,
    required String emoji,
    required String activeEmoji,
    required int count,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () => widget.onReactionTap(key),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE2F0E7) : const Color(0xFFF7F5F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? const Color(0xFF3B5648) : const Color(0xFFEBE6DF),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? activeEmoji : emoji,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(width: 5),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                color:
                    isActive ? const Color(0xFF2C4C3B) : MindColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiPill({
    required String emoji,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE2F0E7) : const Color(0xFFF7F5F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? const Color(0xFF3B5648) : const Color(0xFFEBE6DF),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 5),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                color:
                    isActive ? const Color(0xFF2C4C3B) : MindColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    final post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de sección
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Comentarios (${post.totalComments})',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: MindColors.textPrimary,
              ),
            ),
            InkWell(
              onTap: () => setState(() => _showComments = false),
              child: const Text(
                'Ocultar',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: MindColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Lista de comentarios
        if (post.comments.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF9F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Aún no hay comentarios. Comparte unas palabras amables y reflexivas 🌿',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: MindColors.textSecondary,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: post.comments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final comment = post.comments[index];
              return _buildCommentTile(comment);
            },
          ),
        const SizedBox(height: 12),

        // Campo de texto para publicar comentario
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar anónimo del usuario que comenta
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFD6EADA),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.person_outline_rounded,
                size: 16,
                color: Color(0xFF2C4C3B),
              ),
            ),
            const SizedBox(width: 8),

            // Input
            Expanded(
              child: TextField(
                controller: _commentController,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Escribe un comentario anónimo...',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: MindColors.textTertiary,
                  ),
                  filled: true,
                  fillColor: MindColors.surfaceSubtle.withValues(alpha: 0.6),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: MindColors.primary,
                      width: 1.2,
                    ),
                  ),
                ),
                onSubmitted: (_) => _submitComment(),
              ),
            ),
            const SizedBox(width: 6),

            // Botón de Enviar
            IconButton(
              onPressed: _submitComment,
              icon: const Icon(Icons.send_rounded, size: 19),
              color: MindColors.primaryDark,
              splashRadius: 18,
              tooltip: 'Publicar comentario',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentTile(CommunityComment comment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MindColors.divider, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar anónimo
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2F0E7),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 13,
                  color: Color(0xFF2C4C3B),
                ),
              ),
              const SizedBox(width: 6),

              // Nombre anónimo
              const Expanded(
                child: Text(
                  'Usuario anónimo',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: MindColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Tiempo
              Text(
                comment.formattedTimeAgo,
                style: const TextStyle(
                  fontSize: 10,
                  color: MindColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Contenido del comentario
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              comment.content,
              style: const TextStyle(
                fontSize: 12.5,
                color: MindColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
