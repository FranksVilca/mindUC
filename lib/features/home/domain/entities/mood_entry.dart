import 'mood_type.dart';

/// Entidad inmutable que representa el registro diario de estado de ánimo.
class MoodEntry {
  final String id;
  final String userId;
  final String dateString;
  final MoodType mood;
  final int timestampMillis;

  static final RegExp _dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  MoodEntry({
    required this.id,
    required this.userId,
    required this.dateString,
    required this.mood,
    required this.timestampMillis,
  }) {
    if (userId.trim().isEmpty) {
      throw ArgumentError('userId cannot be empty');
    }
    if (!_dateRegex.hasMatch(dateString)) {
      throw ArgumentError('dateString must follow format YYYY-MM-DD');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          dateString == other.dateString &&
          mood == other.mood &&
          timestampMillis == other.timestampMillis;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      dateString.hashCode ^
      mood.hashCode ^
      timestampMillis.hashCode;
}

