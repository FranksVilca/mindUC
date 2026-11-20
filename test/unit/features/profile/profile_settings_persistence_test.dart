import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/domain/entities/user_entity.dart';
import 'package:minduc/features/profile/data/datasources/local_profile_datasource.dart';
import 'package:minduc/features/profile/data/repositories/local_profile_repository_impl.dart';
import 'package:minduc/features/profile/presentation/controllers/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LocalProfileDataSource.clearProfiles();
  });

  group('Profile Settings & Persistence Tests', () {
    test('updateUserProfile updates state and persists to SharedPreferences', () async {
      final ds = LocalProfileDataSource();
      final repo = LocalProfileRepositoryImpl(dataSource: ds);
      final user = UserEntity(
        id: 'user_sofia_01',
        email: 'sofia.valenzuela@uc.cl',
        displayName: 'Sofía Valenzuela',
        department: 'Ingeniería',
        isEmailVerified: true,
        isAnonymous: false,
        createdAt: DateTime(2026, 11, 1),
      );

      final notifier = ProfileNotifier(
        repository: repo,
        currentUser: user,
      );

      // Esperar carga inicial
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(notifier.state.user.fullName, 'Sofía Valenzuela');
      expect(notifier.state.user.career, 'Ingeniería');

      // Modificar datos personales
      final success = await notifier.updateUserProfile(
        fullName: 'Sofía Andrea Valenzuela R.',
        career: 'Ingeniería de Software',
        universityEmail: 'sofia.andrea@uc.cl',
      );

      expect(success, isTrue);
      expect(notifier.state.user.fullName, 'Sofía Andrea Valenzuela R.');
      expect(notifier.state.user.career, 'Ingeniería de Software');
      expect(notifier.state.user.universityEmail, 'sofia.andrea@uc.cl');

      // Limpiar memoria para simular reinicio de sesión
      LocalProfileDataSource.clearProfiles();

      final ds2 = LocalProfileDataSource();
      final repo2 = LocalProfileRepositoryImpl(dataSource: ds2);
      final notifier2 = ProfileNotifier(
        repository: repo2,
        currentUser: user,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Debe haber recuperado los datos actualizados de SharedPreferences
      expect(notifier2.state.user.fullName, 'Sofía Andrea Valenzuela R.');
      expect(notifier2.state.user.career, 'Ingeniería de Software');
      expect(notifier2.state.user.universityEmail, 'sofia.andrea@uc.cl');
    });

    test('User B does not inherit or see User A modified profile', () async {
      final ds = LocalProfileDataSource();

      await ds.updateUserProfile(
        userId: 'user_a',
        fullName: 'Usuario A Modificado',
        career: 'Arquitectura',
        universityEmail: 'a@uc.cl',
      );

      // Consultar User B
      final profileB = await ds.getProfileState(
        userId: 'user_b',
        email: 'b@uc.cl',
        displayName: 'Usuario B',
        department: 'Medicina',
      );

      expect(profileB.user.fullName, 'Usuario B');
      expect(profileB.user.career, 'Medicina');
      expect(profileB.user.universityEmail, 'b@uc.cl');
      expect(profileB.user.fullName, isNot('Usuario A Modificado'));
    });
  });
}
