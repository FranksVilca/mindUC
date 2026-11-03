import '../../../../core/utils/date_formatter.dart';
import 'journal_mood_pulse.dart';

/// Entidad inmutable que modela una reflexión personal en el diario del estudiante.
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.moodPulse,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String content;
  final JournalMoodPulse moodPulse;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Tiempo estimado de lectura en minutos basado en ~180 palabras por minuto.
  int get readingTimeMinutes {
    final words = content
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    final minutes = (words / 180).ceil();
    return minutes > 0 ? minutes : 1;
  }

  /// Cadena amigable de tiempo de lectura (ej. "2 min de lectura").
  String get readingTimeString => '$readingTimeMinutes min de lectura';

  /// Extracto preliminar de contenido truncado para la tarjeta resumen.
  String get previewSnippet {
    final clean = content.replaceAll('\n', ' ').trim();
    if (clean.length <= 130) return clean;
    return '${clean.substring(0, 127)}...';
  }

  /// Fecha formateada en español respetando el estilo de Figma (ej. "Hoy, 24 Octubre · 21:15").
  String get formattedDate {
    final now = DateTime.now();
    final isToday = now.year == createdAt.year &&
        now.month == createdAt.month &&
        now.day == createdAt.day;

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == createdAt.year &&
        yesterday.month == createdAt.month &&
        yesterday.day == createdAt.day;

    final hourStr = createdAt.hour.toString().padLeft(2, '0');
    final minStr = createdAt.minute.toString().padLeft(2, '0');
    final timeStr = '$hourStr:$minStr';

    final monthName = SpanishDateFormatter.months[createdAt.month - 1];

    if (isToday) {
      return 'Hoy, ${createdAt.day} $monthName · $timeStr';
    } else if (isYesterday) {
      return 'Ayer, ${createdAt.day} $monthName · $timeStr';
    } else {
      final dayName = SpanishDateFormatter.weekdays[createdAt.weekday - 1];
      return '$dayName, ${createdAt.day} $monthName';
    }
  }

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    JournalMoodPulse? moodPulse,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      moodPulse: moodPulse ?? this.moodPulse,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          moodPulse == other.moodPulse &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        content,
        moodPulse,
        createdAt,
        updatedAt,
      );
}
