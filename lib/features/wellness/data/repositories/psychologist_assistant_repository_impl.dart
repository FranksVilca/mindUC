import '../../domain/entities/psychologist_message.dart';
import '../../domain/repositories/psychologist_assistant_repository.dart';
import '../datasources/gemini_psychologist_datasource.dart';

/// Implementación concreta del repositorio del orientador psicológico.
class PsychologistAssistantRepositoryImpl implements PsychologistAssistantRepository {
  final GeminiPsychologistDataSource _datasource;

  PsychologistAssistantRepositoryImpl({
    GeminiPsychologistDataSource? datasource,
  }) : _datasource = datasource ?? GeminiPsychologistDataSource();

  @override
  Future<PsychologistMessage> askPsychologist({
    required String userMessage,
    String? currentMood,
    String? studentName,
    List<PsychologistMessage>? history,
  }) {
    return _datasource.askPsychologist(
      userMessage: userMessage,
      currentMood: currentMood,
      studentName: studentName,
      history: history,
    );
  }

  @override
  PsychologistMessage getInitialGreeting({
    String? studentName,
    String? currentMood,
  }) {
    return _datasource.getInitialGreeting(
      studentName: studentName,
      currentMood: currentMood,
    );
  }

  @override
  Future<void> saveCustomApiKey(String key) {
    return _datasource.saveCustomApiKey(key);
  }

  @override
  Future<bool> hasCustomApiKey() async {
    final key = await _datasource.getActiveApiKey();
    return key != null && key.isNotEmpty;
  }
}
