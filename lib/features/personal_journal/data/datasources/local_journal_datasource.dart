import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_mood_pulse.dart';

/// Fuente de datos local en el dispositivo del estudiante (Principio V).
/// Almacena las huellas interiores de forma autónoma, aisladas estrictamente por usuario.
class LocalJournalDataSource {
  static final Map<String, List<JournalEntry>> _userEntries = {};

  LocalJournalDataSource({List<JournalEntry>? initialEntries, String defaultUserId = ''}) {
    if (initialEntries != null) {
      _userEntries[defaultUserId] = List<JournalEntry>.from(initialEntries);
    }
  }

  static void clearEntries() {
    _userEntries.clear();
  }

  /// Entradas iniciales simuladas para tests de diseño de interfaz.
  static List<JournalEntry> get mockInitialEntries {
    final now = DateTime.now();
    return [
      JournalEntry(
        id: 'entry-1',
        title: 'Aprender a soltar lo que no puedo controlar',
        content:
            'Hoy me di cuenta de que preocuparme por el resultado final del proyecto solo me generaba angustia. Decidí enfocarme en los 30 minutos que le dedico cada día y confiar en el proceso. Me siento mucho más serena y con claridad para seguir avanzando paso a paso sin exigirme perfección.',
        moodPulse: JournalMoodPulse.enCalma,
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
      JournalEntry(
        id: 'entry-2',
        title: 'Caminata bajo el sol matutino',
        content:
            'El aire fresco antes de clase me ayudó a ordenar las ideas y dejar atrás la noche de estudio. Sentir el calor suave en el rostro me recordó que la vida universitaria también se compone de pausas amables y momentos de silencio reparador.',
        moodPulse: JournalMoodPulse.agradecida,
        createdAt: DateTime(now.year, now.month, now.day, 8, 30)
            .subtract(const Duration(days: 1)),
      ),
      JournalEntry(
        id: 'entry-3',
        title: 'Mi primer paso diciendo que no',
        content:
            'Poner un límite hoy no me hizo egoísta, me dio el espacio necesario para descansar sin culpas. Fue incómodo al principio pero mi bienestar vale más que complacer a todos a costa de mi propia salud mental.',
        moodPulse: JournalMoodPulse.reflexiva,
        createdAt: DateTime(now.year, now.month, now.day, 14, 0)
            .subtract(const Duration(days: 3)),
      ),
    ];
  }

  /// Retorna las entradas del usuario autenticado ordenadas por fecha descendente.
  /// Un usuario nuevo siempre comienza con una lista vacía.
  Future<List<JournalEntry>> getEntries([String userId = '']) async {
    final list = _userEntries[userId];
    if (list == null) return [];
    final sorted = List<JournalEntry>.from(list)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  /// Inserta una nueva entrada o actualiza la existente para el usuario correspondiente.
  Future<void> saveEntry(JournalEntry entry) async {
    final list = _userEntries.putIfAbsent(entry.userId, () => []);
    final index = list.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      list[index] = entry;
    } else {
      list.insert(0, entry);
    }
  }

  /// Guarda o actualiza un lote de entradas en memoria optimizando la búsqueda por ID
  Future<void> saveEntries(List<JournalEntry> entries, [String userId = '']) async {
    if (entries.isEmpty) return;
    final effectiveUserId = userId.trim().isNotEmpty
        ? userId.trim()
        : (entries.first.userId.trim().isNotEmpty
            ? entries.first.userId.trim()
            : '');

    final list = _userEntries.putIfAbsent(effectiveUserId, () => []);
    final existingMap = {for (int i = 0; i < list.length; i++) list[i].id: i};
    final toInsert = <JournalEntry>[];

    for (final entry in entries) {
      final idx = existingMap[entry.id];
      if (idx != null) {
        list[idx] = entry;
      } else {
        toInsert.add(entry);
      }
    }
    if (toInsert.isNotEmpty) {
      list.insertAll(0, toInsert);
    }
  }

  /// Elimina la entrada con el id dado del usuario.
  Future<void> deleteEntry(String id, [String userId = '']) async {
    final list = _userEntries[userId];
    if (list != null) {
      list.removeWhere((e) => e.id == id);
    }
  }
}
