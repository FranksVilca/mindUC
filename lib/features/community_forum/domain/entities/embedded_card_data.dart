/// Tipos de tarjetas complementarias de bienestar incrustadas en los hilos.
enum EmbeddedCardType {
  none,
  insightNotice,
  breathingPrompt,
  topReply,
}

/// Value Object inmutable que representa la información de la tarjeta incrustada.
class EmbeddedCardData {
  final EmbeddedCardType type;
  final String title;
  final String subtitle;
  final String? actionLabel;

  const EmbeddedCardData({
    required this.type,
    required this.title,
    this.subtitle = '',
    this.actionLabel,
  });

  bool get hasCard => type != EmbeddedCardType.none;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmbeddedCardData &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          title == other.title &&
          subtitle == other.subtitle &&
          actionLabel == other.actionLabel;

  @override
  int get hashCode =>
      type.hashCode ^ title.hashCode ^ subtitle.hashCode ^ actionLabel.hashCode;
}
