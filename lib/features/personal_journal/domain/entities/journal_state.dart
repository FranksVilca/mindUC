import 'journal_entry.dart';
import 'journal_mood_pulse.dart';

/// Estado inmutable del módulo de Diario Personal administrado por Riverpod.
class JournalState {
  const JournalState({
    this.entries = const [],
    this.selectedMoodPulse = JournalMoodPulse.enCalma,
    this.isLoading = false,
  });

  final List<JournalEntry> entries;
  final JournalMoodPulse selectedMoodPulse;
  final bool isLoading;

  /// Cantidad total de huellas interiores registradas.
  int get entryCount => entries.length;

  /// Indica si existen reflexiones registradas en el dispositivo.
  bool get hasEntries => entries.isNotEmpty;

  JournalState copyWith({
    List<JournalEntry>? entries,
    JournalMoodPulse? selectedMoodPulse,
    bool? isLoading,
  }) {
    return JournalState(
      entries: entries ?? this.entries,
      selectedMoodPulse: selectedMoodPulse ?? this.selectedMoodPulse,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalState &&
          runtimeType == other.runtimeType &&
          selectedMoodPulse == other.selectedMoodPulse &&
          isLoading == other.isLoading &&
          _listEquals(entries, other.entries);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(entries),
        selectedMoodPulse,
        isLoading,
      );

  static bool _listEquals(List<JournalEntry> a, List<JournalEntry> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

