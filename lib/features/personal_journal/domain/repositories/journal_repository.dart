import '../entities/journal_entry.dart';

/// Contrato abstracto para el repositorio de Diario Personal.
/// Garantiza la separación de Clean Architecture entre dominio y datos.
abstract class JournalRepository {
  /// Obtiene la lista de reflexiones íntimas ordenadas cronológicamente.
  Future<List<JournalEntry>> getEntries();

  /// Persiste una nueva reflexión o actualiza una existente en el almacenamiento local.
  Future<void> saveEntry(JournalEntry entry);

  /// Elimina definitivamente una reflexión del dispositivo del estudiante.
  Future<void> deleteEntry(String id);
}

