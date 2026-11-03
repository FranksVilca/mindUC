import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/fake_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

/// Proveedor del repositorio de autenticación (por defecto con FakeDataSource para desarrollo).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(fakeDataSource: FakeAuthDataSource());
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

/// Proveedor del Stream de estado del usuario autenticado.
final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});
