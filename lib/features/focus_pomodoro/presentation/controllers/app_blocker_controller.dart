import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/datasources/local_app_blocker_datasource.dart';
import '../../data/repositories/local_app_blocker_repository_impl.dart';
import '../../domain/entities/app_blocker_status.dart';
import '../../domain/entities/blocked_app.dart';
import '../../domain/repositories/app_blocker_repository.dart';

/// Proveedor para la fuente de datos local del bloqueador de aplicaciones.
final appBlockerDatasourceProvider = Provider<LocalAppBlockerDatasource>((ref) {
  return LocalAppBlockerDatasource();
});

/// Proveedor para el repositorio de bloqueo de aplicaciones.
final appBlockerRepositoryProvider = Provider<AppBlockerRepository>((ref) {
  final ds = ref.watch(appBlockerDatasourceProvider);
  return LocalAppBlockerRepositoryImpl(datasource: ds);
});

/// Estado inmutable para el módulo de bloqueo de aplicaciones.
class AppBlockerState {
  const AppBlockerState({
    this.availableApps = BlockedApp.defaultApps,
    this.blockedApps = const [],
    this.status = BlockerPermissionStatus.inactive,
    this.isBlockerEnabled = false,
    this.blockingDurationMinutes = 25,
    this.isLoading = false,
    this.searchQuery = '',
  });

  final List<BlockedApp> availableApps;
  final List<BlockedApp> blockedApps;
  final BlockerPermissionStatus status;
  final bool isBlockerEnabled;
  final int blockingDurationMinutes;
  final bool isLoading;
  final String searchQuery;

  List<BlockedApp> get filteredAvailableApps {
    if (searchQuery.trim().isEmpty) return availableApps;
    final q = searchQuery.toLowerCase().trim();
    return availableApps.where((app) {
      return app.name.toLowerCase().contains(q) ||
          app.category.toLowerCase().contains(q);
    }).toList();
  }

  AppBlockerState copyWith({
    List<BlockedApp>? availableApps,
    List<BlockedApp>? blockedApps,
    BlockerPermissionStatus? status,
    bool? isBlockerEnabled,
    int? blockingDurationMinutes,
    bool? isLoading,
    String? searchQuery,
  }) {
    return AppBlockerState(
      availableApps: availableApps ?? this.availableApps,
      blockedApps: blockedApps ?? this.blockedApps,
      status: status ?? this.status,
      isBlockerEnabled: isBlockerEnabled ?? this.isBlockerEnabled,
      blockingDurationMinutes:
          blockingDurationMinutes ?? this.blockingDurationMinutes,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Proveedor del controlador reactivo para el bloqueo de aplicaciones.
final appBlockerControllerProvider =
    StateNotifierProvider<AppBlockerNotifier, AppBlockerState>((ref) {
  final repo = ref.watch(appBlockerRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  final userId = currentUser?.id ?? 'default_user';
  return AppBlockerNotifier(repository: repo, userId: userId);
});

/// Controlador del bloqueo de aplicaciones y configuración por usuario.
class AppBlockerNotifier extends StateNotifier<AppBlockerState> {
  AppBlockerNotifier({
    required AppBlockerRepository repository,
    required String userId,
    AppBlockerState? initialState,
  })  : _repository = repository,
        _userId = userId,
        super(initialState ?? const AppBlockerState()) {
    loadApps();
  }

  final AppBlockerRepository _repository;
  final String _userId;

  /// Carga el catálogo de aplicaciones y preferencias del usuario autenticado.
  Future<void> loadApps() async {
    state = state.copyWith(isLoading: true);

    try {
      final available = await _repository.getAvailableApps(_userId);
      final blocked = available.where((a) => a.isBlocked).toList();
      final isEnabled = await _repository.isBlockerActive(_userId);
      final duration = await _repository.getBlockingDuration(_userId);
      final status = await _repository.checkPermissionStatus(isEnabled: isEnabled);

      state = state.copyWith(
        availableApps: available,
        blockedApps: blocked,
        isBlockerEnabled: isEnabled,
        blockingDurationMinutes: duration,
        status: status,
        isLoading: false,
      );

      if (isEnabled) {
        await _repository.setBlockerActive(
          _userId,
          true,
          durationMinutes: duration,
        );
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Alterna la selección de una aplicación para bloquearla o desbloquearla.
  Future<void> toggleAppSelection(String appId, bool isBlocked) async {
    final updatedAvailable = state.availableApps.map((app) {
      if (app.id == appId || app.packageName == appId) {
        return app.copyWith(isBlocked: isBlocked);
      }
      return app;
    }).toList();

    final updatedBlocked = updatedAvailable.where((a) => a.isBlocked).toList();

    state = state.copyWith(
      availableApps: updatedAvailable,
      blockedApps: updatedBlocked,
    );

    await _repository.saveBlockedApps(_userId, updatedAvailable);
  }

  /// Elimina una aplicación de la lista de bloqueo con un solo toque en el chip.
  Future<void> removeBlockedApp(String appId) async {
    await toggleAppSelection(appId, false);
  }

  /// Incorpora una nueva aplicación personalizada con nombre y categoría elegidos por el usuario.
  Future<void> addCustomApp(String name, {String category = 'Personalizada'}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final lower = trimmed.toLowerCase();
    final existingIndex = state.availableApps.indexWhere((a) =>
        a.name.toLowerCase() == lower ||
        a.packageName.toLowerCase() == lower ||
        (lower.contains('instagram') && a.packageName.contains('instagram')) ||
        (lower.contains('tiktok') &&
            (a.packageName.contains('tiktok') ||
                a.packageName.contains('musically'))) ||
        (lower.contains('whatsapp') && a.packageName.contains('whatsapp')) ||
        (lower.contains('aliexpress') && a.packageName.contains('aliexpress')));

    if (existingIndex != -1) {
      final existing = state.availableApps[existingIndex];
      await toggleAppSelection(existing.id, true);
      return;
    }

    String canonicalPackage = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    if (lower.contains('instagram')) {
      canonicalPackage = 'com.instagram.android';
    } else if (lower.contains('tiktok') || lower.contains('musically')) {
      canonicalPackage = 'com.zhiliaoapp.musically';
    } else if (lower.contains('whatsapp')) {
      canonicalPackage = 'com.whatsapp';
    } else if (lower.contains('facebook')) {
      canonicalPackage = 'com.facebook.katana';
    } else if (lower.contains('youtube')) {
      canonicalPackage = 'com.google.android.youtube';
    } else if (lower.contains('aliexpress')) {
      canonicalPackage = 'com.alibaba.aliexpresshd';
    } else if (lower.contains('temu')) {
      canonicalPackage = 'com.einnovation.temu';
    } else if (lower.contains('twitter') || lower == 'x') {
      canonicalPackage = 'com.twitter.android';
    } else if (trimmed.contains('.')) {
      canonicalPackage = trimmed;
    }

    final id = canonicalPackage.startsWith('com.') ||
            canonicalPackage.startsWith('org.')
        ? canonicalPackage
        : 'custom_${DateTime.now().millisecondsSinceEpoch}';

    final newApp = BlockedApp(
      id: id,
      name: trimmed,
      packageName: canonicalPackage,
      category: category,
      isBlocked: true,
      dotColorValue: 0xFF2E7D32,
    );

    final updatedAvailable = [newApp, ...state.availableApps];
    final updatedBlocked = updatedAvailable.where((a) => a.isBlocked).toList();

    state = state.copyWith(
      availableApps: updatedAvailable,
      blockedApps: updatedBlocked,
    );

    await _repository.saveBlockedApps(_userId, updatedAvailable);
  }

  /// Activa o desactiva el modo de bloqueo de aplicaciones.
  Future<void> toggleBlocker(bool enabled) async {
    final newStatus = await _repository.checkPermissionStatus(isEnabled: enabled);

    var currentBlocked = state.blockedApps;
    var currentAvailable = state.availableApps;
    if (enabled && currentBlocked.isEmpty) {
      currentAvailable = currentAvailable.map((app) {
        if (LocalAppBlockerDatasource.isDefaultDistractor(app.packageName, app.name)) {
          return app.copyWith(isBlocked: true);
        }
        return app;
      }).toList();
      currentBlocked = currentAvailable.where((a) => a.isBlocked).toList();
      if (currentBlocked.isEmpty) {
        currentBlocked = BlockedApp.defaultApps.take(3).toList();
      }
      await _repository.saveBlockedApps(_userId, currentAvailable);
    }

    state = state.copyWith(
      isBlockerEnabled: enabled,
      status: newStatus,
      availableApps: currentAvailable,
      blockedApps: currentBlocked,
    );

    await _repository.setBlockerActive(
      _userId,
      enabled,
      durationMinutes: state.blockingDurationMinutes,
    );
  }

  /// Actualiza la duración del período de bloqueo en minutos.
  Future<void> setBlockingDuration(int minutes) async {
    state = state.copyWith(blockingDurationMinutes: minutes);
    await _repository.saveBlockingDuration(_userId, minutes);
  }

  /// Solicita los permisos necesarios del sistema operativo.
  Future<bool> requestPermissions() async {
    final result = await _repository.requestPermissions();
    final updatedStatus = await _repository.checkPermissionStatus(
      isEnabled: state.isBlockerEnabled,
    );
    state = state.copyWith(status: updatedStatus);
    return result;
  }

  /// Reevalúa el estado actual de los permisos del sistema operativo (ej. al reanudar la app desde Ajustes).
  Future<void> refreshPermissionStatus() async {
    final updatedStatus = await _repository.checkPermissionStatus(
      isEnabled: state.isBlockerEnabled,
    );
    if (state.status != updatedStatus) {
      state = state.copyWith(status: updatedStatus);
    }
  }

  /// Actualiza el filtro de búsqueda de aplicaciones.
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}
