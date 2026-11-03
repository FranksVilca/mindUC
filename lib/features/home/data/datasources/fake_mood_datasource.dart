import '../models/mood_model.dart';

/// Fuente de datos simulada en memoria para tests y desarrollo local offline.
class FakeMoodDataSource {
  final Map<String, MoodModel> _storage = {};

  FakeMoodDataSource([Map<String, MoodModel>? initialData]) {
    if (initialData != null) {
      _storage.addAll(initialData);
    }
  }

  Future<MoodModel?> getMood(String userId, String dateString) async {
    final key = '${userId}_$dateString';
    return _storage[key];
  }

  Future<MoodModel> saveMood(MoodModel model) async {
    final key = '${model.userId}_${model.dateString}';
    _storage[key] = model;
    return model;
  }

  Future<List<MoodModel>> getWeeklyMoods(String userId) async {
    return _storage.values
        .where((entry) => entry.userId == userId)
        .toList()
      ..sort((a, b) => b.timestampMillis.compareTo(a.timestampMillis));
  }

  void clear() {
    _storage.clear();
  }
}
