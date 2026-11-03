import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_mood_pulse.dart';

/// Fuente de datos local en el dispositivo del estudiante (Principio V).
/// Almacena las huellas interiores de forma autónoma sin conexiones de red.
class LocalJournalDataSource {
  LocalJournalDataSource({List<JournalEntry>? initialEntries}) {
    if (initialEntries != null) {
      _entries.addAll(initialEntries);
    } else {
      _entries.addAll(_mockInitialEntries);
    }
  }

  final List<JournalEntry> _entries = [];

  static List<JournalEntry> get _mockInitialEntries {
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

  /// Retorna una copia de las entradas ordenadas por fecha descendente.
  Future<List<JournalEntry>> getEntries() async {
    final sorted = List<JournalEntry>.from(_entries)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  /// Inserta una nueva entrada o actualiza la existente.
  Future<void> saveEntry(JournalEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      _entries[index] = entry;
    } else {
      _entries.insert(0, entry);
    }
  }

  /// Elimina la entrada con el id dado.
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
  }
}
