import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/data/datasources/local_app_blocker_datasource.dart';
import 'package:minduc/features/focus_pomodoro/data/repositories/local_app_blocker_repository_impl.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/app_blocker_status.dart';
import 'package:minduc/features/focus_pomodoro/presentation/controllers/app_blocker_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late LocalAppBlockerDatasource datasource;
  late LocalAppBlockerRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    datasource = LocalAppBlockerDatasource(preferences: prefs);
    repository = LocalAppBlockerRepositoryImpl(datasource: datasource);
  });

  group('AppBlockerController & Repository Unit Tests', () {
    test('loads default apps catalog when user has no prior preferences', () async {
      final controller = AppBlockerNotifier(
        repository: repository,
        userId: 'user_1',
      );

      // Wait for loadApps
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.state.availableApps.isNotEmpty, isTrue);
      expect(controller.state.blockedApps.isNotEmpty, isTrue);
      expect(controller.state.isBlockerEnabled, isFalse);
      expect(controller.state.status, BlockerPermissionStatus.inactive);
    });

    test('toggleAppSelection adds and removes apps from blocked list and persists', () async {
      final controller = AppBlockerNotifier(
        repository: repository,
        userId: 'user_1',
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Seleccionar YouTube para bloquear
      await controller.toggleAppSelection('youtube', true);
      expect(controller.state.blockedApps.any((a) => a.id == 'youtube'), isTrue);

      // Desmarcar Instagram
      await controller.toggleAppSelection('instagram', false);
      expect(controller.state.blockedApps.any((a) => a.id == 'instagram'), isFalse);

      // Cargar nuevo controller con mismo usuario para verificar persistencia
      final reloadedController = AppBlockerNotifier(
        repository: repository,
        userId: 'user_1',
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(reloadedController.state.blockedApps.any((a) => a.id == 'youtube'), isTrue);
      expect(reloadedController.state.blockedApps.any((a) => a.id == 'instagram'), isFalse);
    });

    test('removeBlockedApp removes app from blocked list directly', () async {
      final controller = AppBlockerNotifier(
        repository: repository,
        userId: 'user_1',
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.state.blockedApps.any((a) => a.id == 'tiktok'), isTrue);

      await controller.removeBlockedApp('tiktok');
      expect(controller.state.blockedApps.any((a) => a.id == 'tiktok'), isFalse);
    });

    test('addCustomApp adds new user-defined application and marks as blocked', () async {
      final controller = AppBlockerNotifier(
        repository: repository,
        userId: 'user_1',
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await controller.addCustomApp('Duolingo', category: 'Educación');

      expect(controller.state.availableApps.any((a) => a.name == 'Duolingo'), isTrue);
      expect(controller.state.blockedApps.any((a) => a.name == 'Duolingo'), isTrue);
    });

    test('setBlockingDuration updates and persists duration in minutes', () async {
      final controller = AppBlockerNotifier(
        repository: repository,
        userId: 'user_1',
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await controller.setBlockingDuration(45);
      expect(controller.state.blockingDurationMinutes, 45);

      final reloaded = AppBlockerNotifier(
        repository: repository,
        userId: 'user_1',
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(reloaded.state.blockingDurationMinutes, 45);
    });

    test('User isolation: changes by User A do not affect User B', () async {
      final controllerA = AppBlockerNotifier(
        repository: repository,
        userId: 'user_A',
      );
      final controllerB = AppBlockerNotifier(
        repository: repository,
        userId: 'user_B',
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // User A agrega app personalizada
      await controllerA.addCustomApp('Reddit Custom');
      await controllerA.setBlockingDuration(60);

      // User B no debe tener la app personalizada ni la duración de User A
      expect(controllerB.state.availableApps.any((a) => a.name == 'Reddit Custom'), isFalse);
      expect(controllerB.state.blockingDurationMinutes, 25);
    });
  });
}
