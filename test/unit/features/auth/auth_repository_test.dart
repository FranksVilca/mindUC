import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  group('AuthRepositoryImpl Unit Tests', () {
    late FakeAuthDataSource fakeDataSource;
    late AuthRepositoryImpl repository;

    setUp(() {
      fakeDataSource = FakeAuthDataSource();
      repository = AuthRepositoryImpl(fakeDataSource: fakeDataSource);
    });

    tearDown(() {
      fakeDataSource.dispose();
    });

    test('signUpWithEmailAndPassword returns UserEntity on valid credentials', () async {
      final result = await repository.signUpWithEmailAndPassword(
        email: 'camila.soto@uc.cl',
        password: 'password123',
        displayName: 'Camila Soto',
        department: 'Psicología',
      );

      expect(result.isSuccess, isTrue);
      final user = result.dataOrNull!;
      expect(user.email, equals('camila.soto@uc.cl'));
      expect(user.isInstitutional, isTrue);
      expect(user.displayName, equals('Camila Soto'));
      expect(repository.currentUser?.email, equals('camila.soto@uc.cl'));
    });

    test('signUpWithEmailAndPassword fails with ValidationFailure on invalid email', () async {
      final result = await repository.signUpWithEmailAndPassword(
        email: 'invalid-email',
        password: 'password123',
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull?.message, contains('Correo inválido'));
    });

    test('signInWithEmailAndPassword succeeds with correct credentials', () async {
      final result = await repository.signInWithEmailAndPassword(
        email: 'camila.soto@uc.cl',
        password: 'validPassword',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.displayName, equals('Camila Soto'));
    });

    test('signOut clears current user and emits null', () async {
      await repository.signInWithEmailAndPassword(
        email: 'camila.soto@uc.cl',
        password: 'password',
      );
      expect(repository.currentUser, isNotNull);

      final signOutResult = await repository.signOut();
      expect(signOutResult.isSuccess, isTrue);
      expect(repository.currentUser, isNull);
    });
  });
}

