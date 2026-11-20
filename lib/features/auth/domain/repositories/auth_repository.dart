import 'dart:async';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/user_entity.dart';

/// Contrato abstracto de repositorio de autenticación según Clean Architecture.
abstract interface class AuthRepository {
  /// Emite cambios reactivos en la sesión del usuario.
  Stream<UserEntity?> authStateChanges();

  /// Retorna el usuario autenticado actualmente en memoria o caché local.
  UserEntity? get currentUser;

  /// Registra un estudiante con correo institucional o personal, contraseña y avatar opcional.
  Future<Result<UserEntity, AppFailure>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
    String? department,
    String? photoUrl,
  });

  /// Inicia sesión con correo y contraseña.
  Future<Result<UserEntity, AppFailure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Envía correo de recuperación de contraseña.
  Future<Result<void, AppFailure>> sendPasswordResetEmail(String email);

  /// Cierra la sesión activa en este dispositivo.
  Future<Result<void, AppFailure>> signOut();

  /// Elimina la cuenta y todos los datos personales del estudiante de Firebase.
  Future<Result<void, AppFailure>> deleteAccount();
}

