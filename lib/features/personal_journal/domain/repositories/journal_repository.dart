import '../entities/journal_entry.dart';

/// Contrato abstracto para el repositorio de Diario Personal.
/// Garantiza la separación de Clean Architecture entre dominio y datos con aislamiento por usuario.
abstract class JournalRepository {
  /// Obtiene la lista de reflexiones íntimas del usuario ordenadas cronológicamente.
  Future<List<JournalEntry>> getEntries([String userId = '']);

  /// Persiste una nueva reflexión o actualiza una existente para el usuario autenticado.
  Future<void> saveEntry(JournalEntry entry);

  /// Elimina definitivamente una reflexión del dispositivo del estudiante.
  Future<void> deleteEntry(String id, [String userId = '']);
}
