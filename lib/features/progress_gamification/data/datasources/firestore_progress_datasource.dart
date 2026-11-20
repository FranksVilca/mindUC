import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/active_streak.dart';
import '../../domain/entities/organic_achievement.dart';
import '../../domain/entities/progress_summary_state.dart';
import '../../domain/entities/weekly_intention.dart';
import '../../domain/entities/weekly_pause_metrics.dart';
import 'local_progress_datasource.dart';

/// Fuente de datos de Cloud Firestore para el progreso y gamificación compasiva.
/// Almacena y sincroniza métricas en:
/// `users/{userId}/progress/summary`
class FirestoreProgressDataSource {
  final FirebaseService _firebaseService;

  FirestoreProgressDataSource({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  DocumentReference<Map<String, dynamic>> _doc(String userId) =>
      _firebaseService.progressDoc(userId);

  /// Recupera el estado de progreso del usuario desde Cloud Firestore
  Future<ProgressSummaryState> getProgressSummary(String userId) async {
    final cleanUid = userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    final docSnapshot = await _doc(cleanUid).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return _fromFirestore(docSnapshot.data()!);
    }

    return LocalProgressDataSource.initialEmptyState;
  }

  /// Guarda o actualiza el estado completo de progreso en Cloud Firestore
  Future<void> saveProgressSummary(String userId, ProgressSummaryState state) async {
    final cleanUid = userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    final data = _toFirestore(state);
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _doc(cleanUid).set(data, SetOptions(merge: true));
  }

  /// Conmuta o incrementa atómicamente el avance de una intención semanal en una transacción
  Future<ProgressSummaryState> toggleIntentionProgress(
    String intentionId,
    String userId,
  ) async {
    final cleanUid = userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    final docRef = _doc(cleanUid);

    return await _firebaseService.firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final current = (snapshot.exists && snapshot.data() != null)
          ? _fromFirestore(snapshot.data()!)
          : LocalProgressDataSource.initialEmptyState;

      final updatedIntentions = current.intentions.map((intention) {
        if (intention.id != intentionId) return intention;

        if (intention.isCompleted) {
          final newUnits = intention.targetUnits > 1 ? intention.targetUnits - 1 : 0;
          return intention.copyWith(
            currentUnits: newUnits,
            isCompleted: false,
          );
        } else {
          final newUnits = intention.currentUnits + 1;
          final completed = newUnits >= intention.targetUnits;
          return intention.copyWith(
            currentUnits: newUnits.clamp(0, intention.targetUnits),
            isCompleted: completed,
          );
        }
      }).toList();

      final updatedState = current.copyWith(intentions: updatedIntentions);
      final data = _toFirestore(updatedState);
      data['updatedAt'] = FieldValue.serverTimestamp();

      transaction.set(docRef, data, SetOptions(merge: true));
      return updatedState;
    });
  }

  /// Incrementa atómicamente el contador de sesiones Pomodoro
  Future<void> incrementPomodoroSession(String userId) async {
    final cleanUid = userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    await _doc(cleanUid).set({
      'metrics': {
        'pomodoroSessions': FieldValue.increment(1),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Acumula minutos de respiración guiada consciente
  Future<void> recordBreathingMinutes(int minutes, String userId) async {
    final cleanUid = userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    await _doc(cleanUid).set({
      'metrics': {
        'breathingMinutes': FieldValue.increment(minutes),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Actualiza el recuento de huellas en el diario interior
  Future<void> updateJournalEntriesCount(int count, String userId) async {
    final cleanUid = userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    await _doc(cleanUid).set({
      'metrics': {
        'journalEntriesCount': count,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ===========================================================================
  // SERIALIZACIÓN
  // ===========================================================================

  Map<String, dynamic> _toFirestore(ProgressSummaryState s) {
    return {
      'streak': {
        'daysCount': s.streak.daysCount,
        'message': s.streak.message,
        'completedDays': s.streak.completedDays,
        'currentDayIndex': s.streak.currentDayIndex,
      },
      'metrics': {
        'breathingMinutes': s.metrics.breathingMinutes,
        'pomodoroSessions': s.metrics.pomodoroSessions,
        'journalEntriesCount': s.metrics.journalEntriesCount,
        'balancePercentage': s.metrics.balancePercentage,
      },
      'quote': s.quote,
      'quoteSubtitle': s.quoteSubtitle,
      'intentions': s.intentions
          .map((i) => {
                'id': i.id,
                'title': i.title,
                'currentUnits': i.currentUnits,
                'targetUnits': i.targetUnits,
                'unitLabel': i.unitLabel,
                'isCompleted': i.isCompleted,
                'iconType': i.iconType.name,
              })
          .toList(),
      'achievements': s.achievements
          .map((a) => {
                'id': a.id,
                'title': a.title,
                'description': a.description,
                'category': a.category.name,
                'isBloomed': a.isBloomed,
                'currentProgress': a.currentProgress,
                'maxProgress': a.maxProgress,
                'progressLabel': a.progressLabel,
              })
          .toList(),
    };
  }

  ProgressSummaryState _fromFirestore(Map<String, dynamic> data) {
    final rawStreak = data['streak'] as Map<String, dynamic>?;
    final rawMetrics = data['metrics'] as Map<String, dynamic>?;

    final streak = rawStreak != null
        ? ActiveStreak(
            daysCount: rawStreak['daysCount'] as int? ?? 0,
            message: rawStreak['message'] as String? ?? 'Sigue adelante',
            completedDays: (rawStreak['completedDays'] as List<dynamic>?)
                    ?.map((e) => e == true)
                    .toList() ??
                const [false, false, false, false, false, false, false],
            currentDayIndex: rawStreak['currentDayIndex'] as int? ?? 0,
          )
        : LocalProgressDataSource.initialEmptyState.streak;

    final metrics = rawMetrics != null
        ? WeeklyPauseMetrics(
            breathingMinutes: rawMetrics['breathingMinutes'] as int? ?? 0,
            pomodoroSessions: rawMetrics['pomodoroSessions'] as int? ?? 0,
            journalEntriesCount: rawMetrics['journalEntriesCount'] as int? ?? 0,
            balancePercentage: rawMetrics['balancePercentage'] as int? ?? 0,
          )
        : LocalProgressDataSource.initialEmptyState.metrics;

    final rawIntentions = data['intentions'] as List?;
    final intentions = rawIntentions != null
        ? rawIntentions.map((i) {
            final map = Map<String, dynamic>.from(i as Map);
            final iconTypeName = map['iconType'] as String?;
            final iconType = IntentionIconType.values.firstWhere(
              (t) => t.name == iconTypeName,
              orElse: () => IntentionIconType.pauses,
            );
            return WeeklyIntention(
              id: map['id'] as String? ?? '',
              title: map['title'] as String? ?? '',
              currentUnits: map['currentUnits'] as int? ?? 0,
              targetUnits: map['targetUnits'] as int? ?? 1,
              unitLabel: map['unitLabel'] as String? ?? '',
              isCompleted: map['isCompleted'] as bool? ?? false,
              iconType: iconType,
            );
          }).toList()
        : <WeeklyIntention>[];

    final rawAchievements = data['achievements'] as List?;
    final achievements = rawAchievements != null
        ? rawAchievements.map((a) {
            final map = Map<String, dynamic>.from(a as Map);
            final catName = map['category'] as String?;
            final category = AchievementCategory.values.firstWhere(
              (c) => c.name == catName,
              orElse: () => AchievementCategory.peace,
            );
            return OrganicAchievement(
              id: map['id'] as String? ?? '',
              title: map['title'] as String? ?? '',
              description: map['description'] as String? ?? '',
              category: category,
              isBloomed: map['isBloomed'] as bool? ?? false,
              currentProgress:
                  (map['currentProgress'] as num?)?.toDouble() ?? 0.0,
              maxProgress:
                  (map['maxProgress'] as num?)?.toDouble() ?? 1.0,
              progressLabel: map['progressLabel'] as String?,
            );
          }).toList()
        : <OrganicAchievement>[];

    return ProgressSummaryState(
      streak: streak,
      metrics: metrics,
      intentions: intentions,
      achievements: achievements,
      quote: data['quote'] as String? ??
          '“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”',
      quoteSubtitle: data['quoteSubtitle'] as String? ??
          'Recordatorio de autocompasión',
    );
  }
}
