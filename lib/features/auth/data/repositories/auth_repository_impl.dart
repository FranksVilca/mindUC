import 'dart:async';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/fake_auth_datasource.dart';

/// Implementación del repositorio de autenticación desacoplada con soporte
/// para Firebase real o FakeDataSource en tests y desarrollo local.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource? _remoteDataSource;
  final FakeAuthDataSource? _fakeDataSource;

  AuthRepositoryImpl({
    FirebaseAuthDataSource? remoteDataSource,
    FakeAuthDataSource? fakeDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _fakeDataSource = fakeDataSource;

  bool get _isFake => _fakeDataSource != null;

  @override
  Stream<UserEntity?> authStateChanges() {
    if (_isFake) {
      return _fakeDataSource!.authStateChanges.map((m) => m?.toDomain());
    }
    return _remoteDataSource!.authStateChanges.map((m) => m?.toDomain());
  }

  @override
  UserEntity? get currentUser {
    if (_isFake) {
      return _fakeDataSource!.currentUser?.toDomain();
    }
    return _remoteDataSource?.currentUser?.toDomain();
  }

  @override
  Future<Result<UserEntity, AppFailure>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
    String? department,
  }) async {
    try {
      if (email.trim().isEmpty || !email.contains('@')) {
        return const FailureResult(ValidationFailure('Correo inválido', field: 'email'));
      }
      if (password.length < 6) {
        return const FailureResult(ValidationFailure('La contraseña debe tener al menos 6 caracteres', field: 'password'));
      }

      final userModel = _isFake
          ? await _fakeDataSource!.signUp(
              email: email,
              password: password,
              displayName: displayName,
              department: department,
            )
          : await _remoteDataSource!.signUp(
              email: email,
              password: password,
              displayName: displayName,
              department: department,
            );

      return Success(userModel.toDomain());
    } catch (e) {
      return FailureResult(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity, AppFailure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = _isFake
          ? await _fakeDataSource!.signIn(email: email, password: password)
          : await _remoteDataSource!.signIn(email: email, password: password);

      return Success(userModel.toDomain());
    } catch (e) {
      return FailureResult(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, AppFailure>> sendPasswordResetEmail(String email) async {
    try {
      if (_isFake) {
        await _fakeDataSource!.sendPasswordReset(email);
      } else {
        await _remoteDataSource!.sendPasswordReset(email);
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, AppFailure>> signOut() async {
    try {
      if (_isFake) {
        await _fakeDataSource!.signOut();
      } else {
        await _remoteDataSource!.signOut();
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, AppFailure>> deleteAccount() async {
    try {
      if (_isFake) {
        await _fakeDataSource!.deleteAccount();
      } else {
        await _remoteDataSource!.deleteAccount();
      }
      return const Success(null);
    } catch (e) {
      return FailureResult(AuthFailure(e.toString()));
    }
  }
}
