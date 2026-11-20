import 'package:flutter/foundation.dart';
import 'agenda_category.dart';

const Object _sentinel = Object();

/// Entidad inmutable que representa una actividad, hábito o compromiso planificado en la agenda.
class AgendaActivity {
  final String id;
  final String userId;
  final String title;
  final String subtitle;
  final DateTime scheduledDateTime;
  final AgendaCategory category;
  final int? reminderMinutesBefore;
  final List<int> reminderMinutesList;
  final bool isCompleted;
  final DateTime createdAt;

  const AgendaActivity({
    required this.id,
    this.userId = '',
    required this.title,
    required this.subtitle,
    required this.scheduledDateTime,
    required this.category,
    this.reminderMinutesBefore,
    this.reminderMinutesList = const [],
    this.isCompleted = false,
    required this.createdAt,
  });

  /// Lista efectiva de minutos de recordatorio antes de la actividad
  List<int> get effectiveReminderMinutes {
    if (reminderMinutesList.isNotEmpty) return reminderMinutesList;
    if (reminderMinutesBefore != null) return [reminderMinutesBefore!];
    return const [];
  }

  /// Hora formateada acorde al diseño visual de Figma (ej. '08:00 AM', '16:00 PM')
  String get formattedTime {
    final hourStr = scheduledDateTime.hour.toString().padLeft(2, '0');
    final minuteStr = scheduledDateTime.minute.toString().padLeft(2, '0');
    final suffix = scheduledDateTime.hour < 12 ? 'AM' : 'PM';
    return '$hourStr:$minuteStr $suffix';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'subtitle': subtitle,
        'scheduledDateTime': scheduledDateTime.toIso8601String(),
        'category': category.name,
        'reminderMinutesBefore':
            reminderMinutesBefore ?? reminderMinutesList.firstOrNull,
        'reminderMinutesList': reminderMinutesList,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AgendaActivity.fromJson(Map<String, dynamic> json) {
    final catName = json['category'] as String?;
    final cat = AgendaCategory.values.firstWhere(
      (c) => c.name == catName,
      orElse: () => AgendaCategory.autocuidado,
    );

    final rawList = json['reminderMinutesList'];
    List<int> reminderList = const [];
    if (rawList is List) {
      reminderList = rawList
          .map((e) => e is int ? e : int.tryParse(e.toString()))
          .whereType<int>()
          .toList();
    } else if (json['reminderMinutesBefore'] is int) {
      reminderList = [json['reminderMinutesBefore'] as int];
    }

    final singleReminder = json['reminderMinutesBefore'] as int? ??
        reminderList.firstOrNull;

    return AgendaActivity(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      scheduledDateTime:
          DateTime.tryParse(json['scheduledDateTime'] as String? ?? '') ??
              DateTime.now(),
      category: cat,
      reminderMinutesBefore: singleReminder,
      reminderMinutesList: reminderList,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  /// Retorna una copia de la actividad con campos modificados
  AgendaActivity copyWith({
    String? id,
    String? userId,
    String? title,
    String? subtitle,
    DateTime? scheduledDateTime,
    AgendaCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
    Object? reminderMinutesBefore = _sentinel,
    Object? reminderMinutesList = _sentinel,
  }) {
    final List<int> updatedList = reminderMinutesList == _sentinel
        ? (reminderMinutesBefore == _sentinel
            ? effectiveReminderMinutes
            : ((reminderMinutesBefore as int?) != null
                ? [reminderMinutesBefore as int]
                : const <int>[]))
        : (reminderMinutesList as List<int>? ?? const <int>[]);

    final int? updatedSingle = reminderMinutesBefore == _sentinel
        ? (reminderMinutesList == _sentinel
            ? this.reminderMinutesBefore
            : updatedList.firstOrNull)
        : (reminderMinutesBefore as int?);

    return AgendaActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      category: category ?? this.category,
      reminderMinutesBefore: updatedSingle,
      reminderMinutesList: updatedList,
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
          userId == other.userId &&
          title == other.title &&
          subtitle == other.subtitle &&
          scheduledDateTime == other.scheduledDateTime &&
          category == other.category &&
          reminderMinutesBefore == other.reminderMinutesBefore &&
          listEquals(reminderMinutesList, other.reminderMinutesList) &&
          isCompleted == other.isCompleted &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      scheduledDateTime.hashCode ^
      category.hashCode ^
      reminderMinutesBefore.hashCode ^
      Object.hashAll(reminderMinutesList) ^
      isCompleted.hashCode ^
      createdAt.hashCode;
}
