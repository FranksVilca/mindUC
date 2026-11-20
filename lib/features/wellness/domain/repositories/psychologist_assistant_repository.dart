import '../entities/psychologist_message.dart';

/// Contrato para el servicio de orientación psicológica IA de mindUC.
abstract class PsychologistAssistantRepository {
  /// Envía la consulta del estudiante y obtiene una respuesta psicológica estructurada.
  Future<PsychologistMessage> askPsychologist({
    required String userMessage,
    String? currentMood,
    String? studentName,
    List<PsychologistMessage>? history,
  });

  /// Obtiene el mensaje de saludo y contención inicial.
  PsychologistMessage getInitialGreeting({
    String? studentName,
    String? currentMood,
  });

  /// Guarda una clave personalizada de Google Gemini API.
  Future<void> saveCustomApiKey(String key);

  /// Retorna si hay una clave de API configurada.
  Future<bool> hasCustomApiKey();
}
