import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/mind_colors.dart';
import '../controllers/journal_controller.dart';
import '../widgets/emotional_pulse_selector.dart';
import '../widgets/journal_entry_card.dart';
import '../widgets/journal_entry_edit_modal.dart';
import '../widgets/journal_header.dart';
import '../widgets/journal_privacy_banner.dart';

/// Pantalla principal de "Mi Diario Personal" acorde al diseño de Figma.
class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journalControllerProvider);
    final notifier = ref.read(journalControllerProvider.notifier);

    return Scaffold(
      backgroundColor: MindColors.background,
      body: SafeArea(
        child: Column(
          children: [
            JournalHeader(
              onBack: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Insignia, Título y Banner de Privacidad Local
                    const JournalPrivacyBanner(),
                    const SizedBox(height: 16),

                    // Botón Principal de Acción: + Nueva entrada reflexiva
                    _NewEntryButton(
                      onTap: () {
                        JournalEntryEditModal.show(
                          context,
                          defaultPulse: state.selectedMoodPulse,
                          onSave: (title, content, pulse) {
                            notifier.createEntry(
                              title: title,
                              content: content,
                              moodPulse: pulse,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Selector de Pulso Emocional ("¿Cómo late tu corazón hoy?")
                    EmotionalPulseSelector(
                      selectedPulse: state.selectedMoodPulse,
                      onPulseSelected: notifier.selectMoodPulse,
                    ),
                    const SizedBox(height: 24),

                    // Cabecera de la cronología "Tus huellas interiores"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.grass_rounded,
                              size: 18,
                              color: MindColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Tus huellas interiores',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: MindColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '${state.entryCount} entradas',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Lista de reflexiones
                    if (state.entries.isEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Aún no tienes huellas registradas en tu dispositivo.\n'
                          'Presiona "+ Nueva entrada reflexiva" para plasmar tu primer pensamiento en calma.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: MindColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ] else ...[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.entries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final entry = state.entries[index];
                          return JournalEntryCard(
                            entry: entry,
                            onEdit: () {
                              JournalEntryEditModal.show(
                                context,
                                existingEntry: entry,
                                defaultPulse: entry.moodPulse,
                                onSave: (title, content, pulse) {
                                  notifier.updateEntry(
                                    id: entry.id,
                                    title: title,
                                    content: content,
                                    moodPulse: pulse,
                                  );
                                },
                              );
                            },
                            onDelete: () {
                              notifier.deleteEntry(entry.id);
                            },
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewEntryButton extends StatelessWidget {
  const _NewEntryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFDEDAF2), // Tono lavanda pastel de Figma
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B72B8).withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit_note_rounded,
              color: Color(0xFF4A4476),
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              '+ Nueva entrada reflexiva',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4476),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

