import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Fuente de datos local para persistir el progreso de relajación y pausas activas por usuario.
class LocalRelaxationDataSource {
  static const String _keyPrefix = 'relaxation_progress_';

  String _getKey(String userId) => '$_keyPrefix$userId';

  /// Obtiene un mapa de `activityId -> completionsCount` para la fecha actual del usuario.
  Future<Map<String, int>> getCompletionsToday(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_getKey(userId));
    if (rawJson == null || rawJson.isEmpty) return {};

    try {
      final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
      final savedDate = decoded['date'] as String?;
      final todayDate = DateTime.now().toIso8601String().split('T').first;

      // Si el día guardado es hoy, retornamos los conteos
      if (savedDate == todayDate) {
        final counts = decoded['counts'] as Map<String, dynamic>? ?? {};
        return counts.map((k, v) => MapEntry(k, (v as num).toInt()));
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  /// Incrementa el contador de culminación de una actividad para el usuario en el día de hoy.
  Future<void> recordCompletion(String userId, String activityId) async {
    final prefs = await SharedPreferences.getInstance();
    final todayDate = DateTime.now().toIso8601String().split('T').first;
    final currentCounts = await getCompletionsToday(userId);

    currentCounts[activityId] = (currentCounts[activityId] ?? 0) + 1;

    final dataToSave = {
      'date': todayDate,
      'counts': currentCounts,
    };

    await prefs.setString(_getKey(userId), jsonEncode(dataToSave));
  }

  /// Limpia los datos de pausas de un usuario.
  Future<void> clearUserProgress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getKey(userId));
  }
}
