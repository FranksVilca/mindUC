import 'agenda_category.dart';

/// Entidad inmutable que representa una actividad, hábito o compromiso planificado en la agenda.
class AgendaActivity {
  final String id;
  final String title;
  final String subtitle;
  final DateTime scheduledDateTime;
  final AgendaCategory category;
  final bool isCompleted;
  final DateTime createdAt;

  const AgendaActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.scheduledDateTime,
    required this.category,
    this.isCompleted = false,
    required this.createdAt,
  });

  /// Hora formateada acorde al diseño visual de Figma (ej. '08:00 AM', '16:00 PM')
  String get formattedTime {
    final hourStr = scheduledDateTime.hour.toString().padLeft(2, '0');
    final minuteStr = scheduledDateTime.minute.toString().padLeft(2, '0');
    final suffix = scheduledDateTime.hour < 12 ? 'AM' : 'PM';
    return '$hourStr:$minuteStr $suffix';
  }

  /// Retorna una copia de la actividad con campos modificados
  AgendaActivity copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? scheduledDateTime,
    AgendaCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return AgendaActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgendaActivity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          subtitle == other.subtitle &&
          scheduledDateTime == other.scheduledDateTime &&
          category == other.category &&
          isCompleted == other.isCompleted &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      scheduledDateTime.hashCode ^
      category.hashCode ^
      isCompleted.hashCode ^
      createdAt.hashCode;
}

