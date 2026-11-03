import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:minduc/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:minduc/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  group('AuthUiNotifier Unit Tests', () {
    late FakeAuthDataSource fakeDataSource;
    late AuthRepositoryImpl repository;
    late SignInUseCase signInUseCase;
    late SignUpUseCase signUpUseCase;
    late AuthUiNotifier notifier;

    setUp(() {
      fakeDataSource = FakeAuthDataSource();
      repository = AuthRepositoryImpl(fakeDataSource: fakeDataSource);
      signInUseCase = SignInUseCase(repository);
      signUpUseCase = SignUpUseCase(repository);
      notifier = AuthUiNotifier(
        signInUseCase: signInUseCase,
        signUpUseCase: signUpUseCase,
        authRepository: repository,
      );
    });

    tearDown(() {
      fakeDataSource.dispose();
      notifier.dispose();
    });

    test('initial state is login mode, password hidden, not loading', () {
      expect(notifier.state.isLoginMode, isTrue);
      expect(notifier.state.isPasswordVisible, isFalse);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('toggleMode toggles between login and register', () {
      notifier.toggleMode();
      expect(notifier.state.isLoginMode, isFalse);

      notifier.toggleMode();
      expect(notifier.state.isLoginMode, isTrue);
    });

    test('togglePasswordVisibility toggles visibility', () {
      notifier.togglePasswordVisibility();
      expect(notifier.state.isPasswordVisible, isTrue);

      notifier.togglePasswordVisibility();
      expect(notifier.state.isPasswordVisible, isFalse);
    });

    test('submit in login mode succeeds with valid credentials', () async {
      final success = await notifier.submit(
        email: 'camila.soto@uc.cl',
        password: 'password',
      );

      expect(success, isTrue);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('submit in register mode creates new account', () async {
      notifier.setLoginMode(false);

      final success = await notifier.submit(
        email: 'nuevo.estudiante@uc.cl',
        password: 'password123',
        displayName: 'Nuevo Estudiante',
        department: 'Ingeniería',
      );

      expect(success, isTrue);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('sendPasswordReset updates isResetEmailSent to true on success', () async {
      final success = await notifier.sendPasswordReset('camila.soto@uc.cl');

      expect(success, isTrue);
      expect(notifier.state.isResetEmailSent, isTrue);
      expect(notifier.state.isLoading, isFalse);
    });
  });
}

