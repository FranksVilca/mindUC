import '../../domain/entities/breathing_session_log.dart';

/// DTO para la persistencia y recuperación de sesiones de respiración en Firestore.
class BreathingSessionModel {
  final String id;
  final String userId;
  final String techniqueId;
  final int durationSeconds;
  final int cyclesCompleted;
  final String dateString;
  final int timestampMillis;

  const BreathingSessionModel({
    required this.id,
    required this.userId,
    required this.techniqueId,
    required this.durationSeconds,
    required this.cyclesCompleted,
    required this.dateString,
    required this.timestampMillis,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'techniqueId': techniqueId,
        'durationSeconds': durationSeconds,
        'cyclesCompleted': cyclesCompleted,
        'dateString': dateString,
        'timestampMillis': timestampMillis,
      };

  factory BreathingSessionModel.fromMap(Map<String, dynamic> map) =>
      BreathingSessionModel(
        id: map['id'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
        techniqueId: map['techniqueId'] as String? ?? 'box_444',
        durationSeconds: map['durationSeconds'] as int? ?? 0,
        cyclesCompleted: map['cyclesCompleted'] as int? ?? 0,
        dateString: map['dateString'] as String? ?? '',
        timestampMillis: map['timestampMillis'] as int? ??
            DateTime.now().millisecondsSinceEpoch,
      );

  factory BreathingSessionModel.fromDomain(BreathingSessionLog log) =>
      BreathingSessionModel(
        id: log.id,
        userId: log.userId,
        techniqueId: log.techniqueId,
        durationSeconds: log.durationSeconds,
        cyclesCompleted: log.cyclesCompleted,
        dateString: log.dateString,
        timestampMillis: log.timestampMillis,
      );

  BreathingSessionLog toDomain() => BreathingSessionLog(
        id: id,
        userId: userId,
        techniqueId: techniqueId,
        durationSeconds: durationSeconds,
        cyclesCompleted: cyclesCompleted,
        dateString: dateString,
        timestampMillis: timestampMillis,
      );
}
