import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../home/presentation/controllers/home_dashboard_controller.dart';
import '../../data/datasources/gemini_psychologist_datasource.dart';
import '../../data/repositories/psychologist_assistant_repository_impl.dart';
import '../../domain/entities/psychologist_message.dart';
import '../../domain/repositories/psychologist_assistant_repository.dart';

/// Provider del DataSource del Psicólogo Orientador
final psychologistDataSourceProvider = Provider<GeminiPsychologistDataSource>((ref) {
  return GeminiPsychologistDataSource();
});

/// Provider del Repositorio del Psicólogo Orientador
final psychologistRepositoryProvider = Provider<PsychologistAssistantRepository>((ref) {
  final ds = ref.watch(psychologistDataSourceProvider);
  return PsychologistAssistantRepositoryImpl(datasource: ds);
});

/// Estado inmutable de la conversación con el psicólogo orientador IA
class PsychologistAssistantState {
  final List<PsychologistMessage> messages;
  final bool isLoading;
  final String? currentMood;
  final String? studentName;
  final bool hasCustomApiKey;
  final String? errorMessage;

  const PsychologistAssistantState({
    this.messages = const [],
    this.isLoading = false,
    this.currentMood,
    this.studentName,
    this.hasCustomApiKey = false,
    this.errorMessage,
  });

  PsychologistAssistantState copyWith({
    List<PsychologistMessage>? messages,
    bool? isLoading,
    String? currentMood,
    String? studentName,
    bool? hasCustomApiKey,
    String? errorMessage,
  }) {
    return PsychologistAssistantState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      currentMood: currentMood ?? this.currentMood,
      studentName: studentName ?? this.studentName,
      hasCustomApiKey: hasCustomApiKey ?? this.hasCustomApiKey,
      errorMessage: errorMessage,
    );
  }
}

/// Provider del controlador reactivo
final psychologistAssistantControllerProvider = StateNotifierProvider<
    PsychologistAssistantNotifier, PsychologistAssistantState>((ref) {
  final repo = ref.watch(psychologistRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  final homeState = ref.watch(homeDashboardControllerProvider);

  final studentName = (currentUser?.displayName != null && currentUser!.displayName!.isNotEmpty)
      ? currentUser.displayName
      : homeState.summary.greetingName;

  final mood = homeState.selectedMood?.label;

  return PsychologistAssistantNotifier(
    repository: repo,
    studentName: studentName,
    currentMood: mood,
  );
});

/// Controlador para la interacción con el psicólogo orientador IA
class PsychologistAssistantNotifier extends StateNotifier<PsychologistAssistantState> {
  final PsychologistAssistantRepository _repository;

  PsychologistAssistantNotifier({
    required PsychologistAssistantRepository repository,
    String? studentName,
    String? currentMood,
  })  : _repository = repository,
        super(PsychologistAssistantState(
          studentName: studentName,
          currentMood: currentMood,
        )) {
    _initialize();
  }

  Future<void> _initialize() async {
    final hasKey = await _repository.hasCustomApiKey();
    final greeting = _repository.getInitialGreeting(
      studentName: state.studentName,
      currentMood: state.currentMood,
    );

    state = state.copyWith(
      hasCustomApiKey: hasKey,
      messages: [greeting],
    );
  }

  /// Envía un mensaje o inquietud al psicólogo y recibe su orientación
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final userMsg = PsychologistMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      errorMessage: null,
    );

    try {
      final reply = await _repository.askPsychologist(
        userMessage: trimmed,
        currentMood: state.currentMood,
        studentName: state.studentName,
        history: state.messages,
      );

      state = state.copyWith(
        messages: [...state.messages, reply],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo generar la recomendación. Intenta nuevamente.',
      );
    }
  }

  /// Guarda una clave personalizada de Google AI Studio
  Future<void> saveApiKey(String key) async {
    await _repository.saveCustomApiKey(key);
    final hasKey = await _repository.hasCustomApiKey();
    state = state.copyWith(hasCustomApiKey: hasKey);
  }

  /// Reinicia la conversación con un nuevo saludo
  void resetConversation() {
    final greeting = _repository.getInitialGreeting(
      studentName: state.studentName,
      currentMood: state.currentMood,
    );
    state = state.copyWith(
      messages: [greeting],
      isLoading: false,
      errorMessage: null,
    );
  }
}
