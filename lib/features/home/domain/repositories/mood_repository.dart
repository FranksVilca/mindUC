import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/mood_entry.dart';
import '../entities/mood_type.dart';

/// Contrato abstracto del repositorio para la persistencia del pulso emocional.
abstract class MoodRepository {
  /// Obtiene el estado de ánimo registrado hoy por el usuario (si existe).
  Future<Result<MoodEntry?, AppFailure>> getTodayMood({
    required String userId,
    required String dateString,
  });

  /// Registra o actualiza el estado de ánimo para la fecha indicada.
  Future<Result<MoodEntry, AppFailure>> saveMood({
    required String userId,
    required String dateString,
    required MoodType mood,
  });

  /// Obtiene los registros de la semana para análisis de bienestar.
  Future<Result<List<MoodEntry>, AppFailure>> getWeeklyMoods({
    required String userId,
  });
}
