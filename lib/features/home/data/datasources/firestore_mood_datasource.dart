import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';

/// Fuente de datos de Cloud Firestore para el registro de estado de ánimo.
/// Almacena el pulso emocional diario en `users/{userId}/mood_entries/{dateString}`.
class FirestoreMoodDataSource {
  final FirebaseService _firebaseService;

  FirestoreMoodDataSource({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firebaseService.moodCollection(userId);

  /// Recupera el estado de ánimo registrado en la fecha indicada
  Future<MoodEntry?> getTodayMood({
    required String userId,
    required String dateString,
  }) async {
    final cleanUid =
        userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    final docSnapshot = await _collection(cleanUid).doc(dateString).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return _fromFirestore(docSnapshot.data()!, dateString);
    }
    return null;
  }

  /// Guarda o actualiza el estado de ánimo para la fecha indicada
  Future<MoodEntry> saveMood({
    required String userId,
    required String dateString,
    required MoodType mood,
  }) async {
    final cleanUid =
        userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    final now = DateTime.now().millisecondsSinceEpoch;

    final entry = MoodEntry(
      id: '${cleanUid}_$dateString',
      userId: cleanUid,
      dateString: dateString,
      mood: mood,
      timestampMillis: now,
    );

    await _collection(cleanUid).doc(dateString).set({
      'id': entry.id,
      'userId': cleanUid,
      'dateString': dateString,
      'moodName': mood.name,
      'timestampMillis': now,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return entry;
  }

  /// Obtiene los registros de la semana para análisis de bienestar
  Future<List<MoodEntry>> getWeeklyMoods({required String userId}) async {
    final cleanUid =
        userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    final snapshot = await _collection(cleanUid)
        .orderBy('dateString', descending: true)
        .limit(7)
        .get();

    return snapshot.docs
        .map((doc) => _fromFirestore(doc.data(), doc.id))
        .toList();
  }

  MoodEntry _fromFirestore(Map<String, dynamic> data, String dateString) {
    final moodName = data['moodName'] as String?;
    final mood = MoodType.values.firstWhere(
      (m) => m.name == moodName,
      orElse: () => MoodType.calma,
    );

    return MoodEntry(
      id: data['id'] as String? ?? 'mood_$dateString',
      userId: data['userId'] as String? ?? '',
      dateString: data['dateString'] as String? ?? dateString,
      mood: mood,
      timestampMillis: data['timestampMillis'] as int? ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }
}
