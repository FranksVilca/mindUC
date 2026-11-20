import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/firebase/firebase_config.dart';
import '../../../../core/firebase/firebase_initializer.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/fake_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_ui_state.dart';

/// Proveedor del repositorio de autenticación con soporte para Firebase y fallback local.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource:
        (FirebaseInitializer.isInitialized && FirebaseConfig.hasCustomCredentials)
            ? FirebaseAuthDataSource()
            : null,
    fakeDataSource: FakeAuthDataSource(),
  );
});

/// Proveedor del caso de uso de inicio de sesión.
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignInUseCase(repo);
});

/// Proveedor del caso de uso de registro.
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repo);
});

/// Proveedor del Stream de sesión del usuario.
final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});

/// Proveedor reactivo del usuario actualmente autenticado.
/// Reacciona inmediatamente a cambios de sesión (login, logout, cambio de cuenta).
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authAsync = ref.watch(authStateChangesProvider);
  return authAsync.asData?.value ?? ref.watch(authRepositoryProvider).currentUser;
});

/// Notifier que gestiona el estado interactivo del formulario de autenticación.
class AuthUiNotifier extends StateNotifier<AuthUiState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final AuthRepository _authRepository;

  AuthUiNotifier({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required AuthRepository authRepository,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _authRepository = authRepository,
        super(const AuthUiState());

  void toggleMode() {
    state = state.copyWith(
      isLoginMode: !state.isLoginMode,
      clearError: true,
    );
  }

  void setLoginMode(bool isLogin) {
    state = state.copyWith(
      isLoginMode: isLogin,
      clearError: true,
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<bool> submit({
    required String email,
    required String password,
    String? displayName,
    String? department,
    String? photoUrl,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    if (state.isLoginMode) {
      final result = await _signInUseCase(email: email, password: password);
      return result.when(
        onSuccess: (_) {
          state = state.copyWith(isLoading: false);
          return true;
        },
        onFailure: (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
          return false;
        },
      );
    } else {
      final result = await _signUpUseCase(
        email: email,
        password: password,
        displayName: displayName,
        department: department,
        photoUrl: photoUrl,
      );
      return result.when(
        onSuccess: (_) {
          state = state.copyWith(isLoading: false);
          return true;
        },
        onFailure: (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
          return false;
        },
      );
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, clearError: true, isResetEmailSent: false);
    final result = await _authRepository.sendPasswordResetEmail(email);
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(isLoading: false, isResetEmailSent: true);
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          isResetEmailSent: false,
        );
        return false;
      },
    );
  }
}

/// Proveedor del controlador de estado de UI de autenticación.
final authUiControllerProvider =
    StateNotifierProvider<AuthUiNotifier, AuthUiState>((ref) {
  return AuthUiNotifier(
    signInUseCase: ref.watch(signInUseCaseProvider),
    signUpUseCase: ref.watch(signUpUseCaseProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
});
