import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/agenda_activity.dart';
import '../../domain/entities/agenda_category.dart';

/// Fuente de datos local para la agenda consciente (Principio V).
/// Aísla estrictamente los eventos y actividades por ID de usuario y persiste en SharedPreferences.
class LocalAgendaDataSource {
  static final Map<String, List<AgendaActivity>> _userActivities = {};

  final SharedPreferences? _preferences;

  LocalAgendaDataSource({
    List<AgendaActivity>? initialActivities,
    String defaultUserId = '',
    SharedPreferences? preferences,
  }) : _preferences = preferences {
    if (initialActivities != null) {
      _userActivities[defaultUserId] = List<AgendaActivity>.from(initialActivities);
    }
  }

  static void clearActivities() {
    _userActivities.clear();
  }

  SharedPreferences? _cachedPrefs;

  Future<SharedPreferences?> _getPrefs() async {
    if (_preferences != null) return _preferences;
    if (_cachedPrefs != null) return _cachedPrefs;
    try {
      _cachedPrefs = await SharedPreferences.getInstance();
      return _cachedPrefs;
    } catch (_) {
      return null;
    }
  }

  String _storageKey(String userId) {
    final cleanId = userId.trim().isEmpty ? 'guest' : userId.trim();
    return 'agenda_activities_$cleanId';
  }

  /// Actividades iniciales de alta fidelidad según el mockup de Figma (24 de Octubre de 2024).
  /// Disponibles exclusivamente para tests específicos de diseño.
  static List<AgendaActivity> get mockInitialActivities {
    const targetYear = 2024;
    const targetMonth = 10;
    const targetDay = 24;

    return [
      AgendaActivity(
        id: 'activity-1',
        title: 'Meditación matutina y respiración',
        subtitle: '10 min de enfoque guiado para iniciar el día en calma.',
        scheduledDateTime: DateTime(targetYear, targetMonth, targetDay, 8, 0),
        category: AgendaCategory.autocuidado,
        isCompleted: true,
        createdAt: DateTime(targetYear, targetMonth, targetDay, 7, 0),
      ),
      AgendaActivity(
        id: 'activity-2',
        title: 'Sesión de estudio concentrado (Pomodoro)',
        subtitle: 'Lectura de apuntes y revisión de metas semanales.',
        scheduledDateTime: DateTime(targetYear, targetMonth, targetDay, 11, 30),
        category: AgendaCategory.estudioTrabajo,
        isCompleted: true,
        createdAt: DateTime(targetYear, targetMonth, targetDay, 7, 30),
      ),
      AgendaActivity(
        id: 'activity-3',
        title: 'Caminata al aire libre sin pantallas',
        subtitle: '25 min en el parque para despejar la vista y desconectar.',
        scheduledDateTime: DateTime(targetYear, targetMonth, targetDay, 16, 0),
        category: AgendaCategory.saludMental,
        isCompleted: false,
        createdAt: DateTime(targetYear, targetMonth, targetDay, 8, 0),
      ),
      AgendaActivity(
        id: 'activity-4',
        title: 'Escribir en mi Diario Personal de gratitud',
        subtitle: 'Anotar 3 momentos significativos vividos hoy.',
        scheduledDateTime: DateTime(targetYear, targetMonth, targetDay, 21, 30),
        category: AgendaCategory.autocuidado,
        isCompleted: false,
        createdAt: DateTime(targetYear, targetMonth, targetDay, 8, 30),
      ),
    ];
  }

  /// Retorna las actividades pertenecientes al usuario autenticado.
  /// Si existen datos persistidos en almacenamiento local, se sincronizan.
  Future<List<AgendaActivity>> getActivities([String userId = '']) async {
    if (!_userActivities.containsKey(userId)) {
      try {
        final prefs = await _getPrefs();
        final raw = prefs?.getString(_storageKey(userId));
        if (raw != null && raw.isNotEmpty) {
          final decoded = jsonDecode(raw);
          if (decoded is List) {
            final loaded = decoded
                .map((item) =>
                    AgendaActivity.fromJson(Map<String, dynamic>.from(item as Map)))
                .toList();
            _userActivities[userId] = loaded;
          }
        }
      } catch (_) {
        // En caso de entorno sin SharedPreferences listo o pruebas unitarias aisladas
      }
    }

    final list = _userActivities[userId];
    if (list == null) return [];
    return List<AgendaActivity>.from(list);
  }

  Future<void> _persistForUser(String userId) async {
    try {
      final prefs = await _getPrefs();
      if (prefs == null) return;
      final list = _userActivities[userId] ?? [];
      final encoded = jsonEncode(list.map((a) => a.toJson()).toList());
      await prefs.setString(_storageKey(userId), encoded);
    } catch (_) {
      // Ignorar fallos de persistencia en tests unitarios sin bindings nativos
    }
  }

  /// Alterna el estado de completitud de una actividad específica del usuario.
  Future<void> toggleActivityCompletion(String id, [String userId = '']) async {
    final list = _userActivities[userId];
    if (list != null) {
      final index = list.indexWhere((a) => a.id == id);
      if (index != -1) {
        final current = list[index];
        list[index] = current.copyWith(isCompleted: !current.isCompleted);
        await _persistForUser(userId);
      }
    }
  }

  /// Agrega o actualiza una actividad asociada al usuario.
  Future<void> saveActivity(AgendaActivity activity) async {
    final list = _userActivities.putIfAbsent(activity.userId, () => []);
    final index = list.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      list[index] = activity;
    } else {
      list.add(activity);
    }
    await _persistForUser(activity.userId);
  }

  /// Agrega o actualiza un lote de actividades en memoria y persiste en disco una sola vez
  Future<void> saveActivities(List<AgendaActivity> activities, [String userId = '']) async {
    if (activities.isEmpty) return;
    final effectiveUserId = userId.trim().isNotEmpty
        ? userId.trim()
        : (activities.first.userId.trim().isNotEmpty
            ? activities.first.userId.trim()
            : 'guest');

    final list = _userActivities.putIfAbsent(effectiveUserId, () => []);
    final existingMap = {for (int i = 0; i < list.length; i++) list[i].id: i};

    for (final activity in activities) {
      final idx = existingMap[activity.id];
      if (idx != null) {
        list[idx] = activity;
      } else {
        list.add(activity);
        existingMap[activity.id] = list.length - 1;
      }
    }
    await _persistForUser(effectiveUserId);
  }

  /// Elimina una actividad del usuario.
  Future<void> deleteActivity(String id, [String userId = '']) async {
    final list = _userActivities[userId];
    if (list != null) {
      list.removeWhere((a) => a.id == id);
      await _persistForUser(userId);
    }
  }
}
