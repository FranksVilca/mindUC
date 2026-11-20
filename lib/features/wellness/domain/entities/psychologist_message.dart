/// Entidad que representa un mensaje en la conversación con el psicólogo orientador IA.
class PsychologistMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? actionType; // 'breathing', 'pomodoro', 'relaxation', 'journal', 'support'
  final String? actionLabel;
  final String? actionRoute;

  const PsychologistMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.actionType,
    this.actionLabel,
    this.actionRoute,
  });

  PsychologistMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? actionType,
    String? actionLabel,
    String? actionRoute,
  }) {
    return PsychologistMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      actionType: actionType ?? this.actionType,
      actionLabel: actionLabel ?? this.actionLabel,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }
}
