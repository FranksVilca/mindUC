import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/datasources/local_progress_datasource.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/entities/progress_summary_state.dart';
import '../../domain/repositories/progress_repository.dart';

/// Proveedor del repositorio de progreso con soporte Cloud Firestore
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl();
});

/// Proveedor reactivo del controlador de progreso y gamificación compasiva aislado por usuario
final progressControllerProvider =
    StateNotifierProvider<ProgressNotifier, ProgressSummaryState>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  final userId = currentUser?.id ?? '';
  return ProgressNotifier(repository, userId: userId);
});

/// Interfaz del controlador de progreso
abstract class IProgressController {
  Future<void> toggleIntention(String intentionId);
  Future<void> refresh();
}

/// StateNotifier reactivo para la pantalla de Progreso & Florecimiento
class ProgressNotifier extends StateNotifier<ProgressSummaryState>
    implements IProgressController {
  final ProgressRepository _repository;
  final String userId;

  ProgressNotifier(this._repository, {this.userId = ''})
      : super(LocalProgressDataSource.initialEmptyState) {
    _load();
  }

  Future<void> _load() async {
    final summary = await _repository.getProgressSummary(userId);
    state = summary;
  }

  @override
  Future<void> toggleIntention(String intentionId) async {
    final updatedSummary =
        await _repository.toggleIntentionProgress(intentionId, userId);
    state = updatedSummary;
  }

  @override
  Future<void> refresh() async {
    final summary = await _repository.getProgressSummary(userId);
    state = summary;
  }
}
