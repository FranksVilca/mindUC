import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/embedded_card_data.dart';

/// Tarjeta completa de una publicación comunitaria en el foro (Principio V).
/// Renderiza avatar sereno, alias efímero, facultad, tiempo, etiquetas,
/// contenido reflexivo, tarjetas incrustadas de bienestar y barra de reacciones conscientes.
class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({
    super.key,
    required this.post,
    required this.onReactionTap,
    this.onEmbeddedActionTap,
    this.onMenuTap,
  });

  final CommunityPost post;
  final void Function(String reactionKey) onReactionTap;
  final VoidCallback? onEmbeddedActionTap;
  final VoidCallback? onMenuTap;

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
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF1ED),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            post.authorRole,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3B5648),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${post.faculty} · ${post.timeAgo}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: MindColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Menú de opciones ⋮
              IconButton(
                onPressed: onMenuTap ?? () => _showCalmOptionsMenu(context),
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: MindColors.textTertiary,
                  size: 20,
                ),
                splashRadius: 20,
                tooltip: 'Opciones de hilo',
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2. Chips temáticos del hilo
          if (post.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: post.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4EFE6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE5DFD3),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: MindColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // 3. Contenido reflexivo
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.45,
              color: MindColors.textPrimary,
            ),
          ),

          // 4. Tarjetas incrustadas condicionales
          if (post.embeddedCard.type != EmbeddedCardType.none) ...[
            const SizedBox(height: 12),
            _buildEmbeddedCard(context),
          ],

          const SizedBox(height: 14),

          // 5. Barra de reacciones empáticas conscientes
          _buildReactionBar(),
        ],
      ),
    );
  }

  Widget _buildEmbeddedCard(BuildContext context) {
    switch (post.embeddedCard.type) {
      case EmbeddedCardType.insightNotice:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1ED),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD6E4DB)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.self_improvement_rounded,
                size: 20,
                color: Color(0xFF5D8572),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  post.embeddedCard.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3B5648),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        );

      case EmbeddedCardType.breathingPrompt:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1ED),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFD6E4DB)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.air_rounded,
                  color: Color(0xFF3B5648),
                  size: 20,
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
                        color: MindColors.textPrimary,
                      ),
                    ),
                    if (post.embeddedCard.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        post.embeddedCard.subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: MindColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  if (onEmbeddedActionTap != null) {
                    onEmbeddedActionTap!();
                  } else {
                    context.push(AppRoutes.breathingSession);
                  }
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F5E4D),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    post.embeddedCard.actionLabel ?? 'Probar',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case EmbeddedCardType.topReply:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F5EE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEBE6D8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 6),
                  Text(
                    post.embeddedCard.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B5648),
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

  Widget _buildReactionBar() {
    return Row(
      children: [
        // Apoyo / Cariño (🤍❤️)
        _buildReactionButton(
          key: 'support',
          emoji: '🤍',
          activeEmoji: '❤️',
          count: post.supportCount,
          isActive: post.hasReaction('support'),
        ),
        const SizedBox(width: 8),

        // Calma (🌿)
        _buildReactionButton(
          key: 'calm',
          emoji: '🌿',
          activeEmoji: '🌿',
          count: post.calmCount,
          isActive: post.hasReaction('calm'),
        ),
        const SizedBox(width: 8),

        // Perspectiva (💡)
        _buildReactionButton(
          key: 'insight',
          emoji: '💡',
          activeEmoji: '💡',
          count: post.insightCount,
          isActive: post.hasReaction('insight'),
        ),
        const SizedBox(width: 8),

        // Abrazo (🫂)
        if (post.hugCount > 0 || post.hasReaction('hug')) ...[
          _buildReactionButton(
            key: 'hug',
            emoji: '🫂',
            activeEmoji: '🫂',
            count: post.hugCount,
            isActive: post.hasReaction('hug'),
          ),
          const SizedBox(width: 8),
        ],

        const Spacer(),

        // Comentarios (💬)
        _buildReactionButton(
          key: 'comment',
          emoji: '💬',
          activeEmoji: '💬',
          count: post.commentCount,
          isActive: false,
          isComment: true,
        ),
      ],
    );
  }

  Widget _buildReactionButton({
    required String key,
    required String emoji,
    required String activeEmoji,
    required int count,
    required bool isActive,
    bool isComment = false,
  }) {
    return InkWell(
      onTap: () => onReactionTap(key),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFE2F0E7)
              : const Color(0xFFF7F5F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? const Color(0xFF3B5648)
                : const Color(0xFFEBE6DF),
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
                color: isActive
                    ? const Color(0xFF2C4C3B)
                    : MindColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
