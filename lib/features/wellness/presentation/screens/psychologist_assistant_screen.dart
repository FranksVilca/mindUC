import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/psychologist_message.dart';
import '../controllers/psychologist_assistant_controller.dart';

/// Pantalla oficial de Orientación Psicológica y Recomendaciones IA de mindUC.
/// Diseñada con estética botánica compasiva y salvaguardas éticas universitarias.
class PsychologistAssistantScreen extends ConsumerStatefulWidget {
  const PsychologistAssistantScreen({super.key});

  @override
  ConsumerState<PsychologistAssistantScreen> createState() =>
      _PsychologistAssistantScreenState();
}

class _PsychologistAssistantScreenState
    extends ConsumerState<PsychologistAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const List<String> _quickPrompts = [
    'Siento mucha ansiedad por los exámenes 📚',
    'No logro concentrarme y procrastino ⏳',
    'Me siento agotado/a y sin energía 🔋',
    'Tengo pensamientos negativos constantes 💭',
    'Dame una técnica rápida para calmarme 🌿',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend([String? textToSend]) {
    final text = textToSend ?? _textController.text;
    if (text.trim().isEmpty) return;

    ref.read(psychologistAssistantControllerProvider.notifier).sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }

  void _showApiKeyDialog() {
    final currentKeyController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.key_rounded, color: MindColors.primaryDark),
            SizedBox(width: 8),
            Text(
              'Clave Google Gemini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'mindUC incluye un motor psicológico TCC offline. Si deseas conectar con Google Gemini 1.5 Flash en tiempo real, puedes ingresar tu API Key gratuita de Google AI Studio.',
              style: TextStyle(fontSize: 13, height: 1.4, color: MindColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: currentKeyController,
              decoration: InputDecoration(
                hintText: 'Pega tu API Key de AI Studio',
                filled: true,
                fillColor: const Color(0xFFF4F6F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MindColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final key = currentKeyController.text.trim();
              await ref
                  .read(psychologistAssistantControllerProvider.notifier)
                  .saveApiKey(key);
              if (ctx.mounted) Navigator.of(ctx).pop();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Configuración de IA actualizada correctamente 🌿'),
                  backgroundColor: Color(0xFF2C5E47),
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(psychologistAssistantControllerProvider);

    ref.listen(psychologistAssistantControllerProvider, (_, next) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: MindColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: MindColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFE2F0E7),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🌿', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MenteCalma',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MindColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Psicólogo Orientador · Confidencial',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: MindColors.primaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Configurar API Key de Gemini',
            icon: const Icon(Icons.vpn_key_outlined, color: MindColors.primaryDark, size: 20),
            onPressed: _showApiKeyDialog,
          ),
          IconButton(
            tooltip: 'Reiniciar conversación',
            icon: const Icon(Icons.refresh_rounded, color: MindColors.textSecondary, size: 22),
            onPressed: () {
              ref
                  .read(psychologistAssistantControllerProvider.notifier)
                  .resetConversation();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Píldora ética de confidencialidad
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF0F6F2),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, size: 14, color: Color(0xFF2C5E47)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Espacio seguro de escucha activa y autorregulación psicológica.',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF2C5E47)),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final msg = state.messages[index];
                  return KeyedSubtree(
                    key: ValueKey(msg.id),
                    child: _buildMessageBubble(msg),
                  );
                },
              ),
            ),

            // Indicador de "Escribiendo..."
            if (state.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: MindColors.primaryDark,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'MenteCalma está reflexionando tu mensaje...',
                            style: TextStyle(fontSize: 12, color: MindColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Sugerencias rápidas de consulta
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: _quickPrompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final prompt = _quickPrompts[index];
                  return ActionChip(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFD4E6DB)),
                    label: Text(
                      prompt,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C5E47),
                      ),
                    ),
                    onPressed: () => _handleSend(prompt),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),

            // Barra de entrada de texto
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Cuéntame qué sientes o qué te preocupa...',
                        hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey.shade500),
                        filled: true,
                        fillColor: const Color(0xFFF6F8F7),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: MindColors.primaryDark,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: () => _handleSend(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(PsychologistMessage msg) {
    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 48),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF2E6347),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              msg.text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14, right: 36),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(color: const Color(0xFFE2EDE5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msg.text,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF1B3626),
                ),
              ),
              if (msg.actionLabel != null && msg.actionRoute != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 0.8, color: Color(0xFFEAF1EC)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    context.push(msg.actionRoute!);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC7E2CF)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.touch_app_rounded, size: 16, color: Color(0xFF2C5E47)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            msg.actionLabel!,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C5E47),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
