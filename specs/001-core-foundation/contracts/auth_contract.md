# Contract: Auth Repository Interface

`lib/features/auth/domain/repositories/auth_repository.dart`

```dart
import 'dart:async';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  /// Emite cambios en el estado de autenticación (usuario activo o null).
  Stream<UserEntity?> authStateChanges();

  /// Retorna el usuario autenticado actualmente en caché o memoria.
  UserEntity? get currentUser;

  /// Registra un nuevo usuario con correo institucional o personal y contraseña.
  Future<Result<UserEntity, AppFailure>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  /// Inicia sesión con correo y contraseña.
  Future<Result<UserEntity, AppFailure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Envía un correo de recuperación de contraseña.
  Future<Result<void, AppFailure>> sendPasswordResetEmail(String email);

  /// Cierra la sesión activa en el dispositivo.
  Future<Result<void, AppFailure>> signOut();

  /// Elimina permanentemente la cuenta y datos del usuario (derecho de supresión).
  Future<Result<void, AppFailure>> deleteAccount();
}
```

