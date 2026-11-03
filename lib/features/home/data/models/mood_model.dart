import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';

/// DTO para la serialización y deserialización de registros de estado de ánimo.
class MoodModel {
  final String id;
  final String userId;
  final String dateString;
  final String mood;
  final int timestampMillis;

  const MoodModel({
    required this.id,
    required this.userId,
    required this.dateString,
    required this.mood,
    required this.timestampMillis,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'dateString': dateString,
        'mood': mood,
        'timestampMillis': timestampMillis,
      };

  factory MoodModel.fromMap(Map<String, dynamic> map) => MoodModel(
        id: map['id'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
        dateString: map['dateString'] as String? ?? '',
        mood: map['mood'] as String? ?? 'calma',
        timestampMillis: map['timestampMillis'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      );

  factory MoodModel.fromDomain(MoodEntry entry) => MoodModel(
        id: entry.id,
        userId: entry.userId,
        dateString: entry.dateString,
        mood: entry.mood.name,
        timestampMillis: entry.timestampMillis,
      );

  MoodEntry toDomain() => MoodEntry(
        id: id,
        userId: userId,
        dateString: dateString,
        mood: MoodType.fromString(mood),
        timestampMillis: timestampMillis,
      );
}

