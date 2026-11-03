import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/mood_entry.dart';
import '../entities/mood_type.dart';
import '../repositories/mood_repository.dart';

/// Caso de uso para obtener el estado de ánimo de hoy del estudiante.
class GetTodayMoodUseCase {
  final MoodRepository _repository;

  GetTodayMoodUseCase(this._repository);

  Future<Result<MoodEntry?, AppFailure>> call({
    required String userId,
    required String dateString,
  }) {
    return _repository.getTodayMood(userId: userId, dateString: dateString);
  }
}

/// Caso de uso para registrar o actualizar el estado de ánimo diario con un toque.
class RecordMoodUseCase {
  final MoodRepository _repository;

  RecordMoodUseCase(this._repository);

  Future<Result<MoodEntry, AppFailure>> call({
    required String userId,
    required String dateString,
    required MoodType mood,
  }) {
    return _repository.saveMood(
      userId: userId,
      dateString: dateString,
      mood: mood,
    );
  }
}

