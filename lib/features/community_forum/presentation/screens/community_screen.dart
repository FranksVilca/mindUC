import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/mind_colors.dart';
import '../controllers/community_controller.dart';
import '../widgets/community_banner_card.dart';
import '../widgets/community_header.dart';
import '../widgets/community_post_card.dart';
import '../widgets/community_post_create_modal.dart';
import '../widgets/mood_filter_chips.dart';

/// Pantalla principal de la Comunidad UC Consciente acorde a Figma (Principio V).
/// Espacio seguro con filtros por sentir, reacciones empáticas y creación de reflexiones anónimas.
class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityControllerProvider);
    final notifier = ref.read(communityControllerProvider.notifier);

    return Scaffold(
      backgroundColor: MindColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera superior serena
            CommunityHeader(
              onBack: () => Navigator.maybePop(context),
            ),

            // Contenido desplazable
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Banner informativo de Espacio Seguro UC
                  const SliverToBoxAdapter(
                    child: CommunityBannerCard(),
                  ),

                  // Botón de acción: "+ Compartir reflexión anónima"
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: InkWell(
                        onTap: () {
                          CommunityPostCreateModal.show(
                            context,
                            onPublish: (
                              authorAlias,
                              authorRole,
                              avatar,
                              faculty,
                              content,
                              tags,
                              moodCategory,
                            ) {
                              notifier.createPost(
                                authorAlias: authorAlias,
                                authorRole: authorRole,
                                avatar: avatar,
                                faculty: faculty,
                                content: content,
                                tags: tags,
                                moodCategory: moodCategory,
                              );
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC5DEC9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFAECBB3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5D8572).withAlpha(20),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                color: Color(0xFF2C4C3B),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '+ Compartir reflexión anónima',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2C4C3B),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Selector horizontal de filtros por sentir
                  SliverToBoxAdapter(
                    child: MoodFilterChips(
                      selectedFilter: state.selectedFilter,
                      activeThreadCount: state.activeThreadCount,
                      onFilterSelected: notifier.selectFilter,
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 6),
                  ),

                  // Lista reactiva de reflexiones comunitarias
                  if (state.filteredPosts.isEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(32),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: MindColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: MindColors.divider),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.spa_rounded,
                              size: 40,
                              color: Color(0xFFA6BCB2),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Aún no hay reflexiones en este sentir',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: MindColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Sé la primera persona en compartir una vivencia o palabra de calma con la comunidad 🌿',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: MindColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.filteredPosts[index];
                          return CommunityPostCard(
                            post: post,
                            onReactionTap: (reactionKey) {
                              notifier.toggleReaction(post.id, reactionKey);
                            },
                          );
                        },
                        childCount: state.filteredPosts.length,
                      ),
                    ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
