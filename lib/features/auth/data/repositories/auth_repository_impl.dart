import 'dart:async';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/firebase/firebase_config.dart';
import '../../../../core/firebase/firebase_initializer.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/fake_auth_datasource.dart';

/// Implementación del repositorio de autenticación híbrido:
/// Sincroniza con Firebase Authentication y Firestore cuando está disponible,
/// y mantiene persistencia local inmediata y offline-first en SharedPreferences
/// para que el usuario nunca quede bloqueado al registrarse o iniciar sesión.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource? _remoteDataSource;
  final FakeAuthDataSource _resolvedFake;
  final StreamController<UserEntity?> _combinedAuthController =
      StreamController<UserEntity?>.broadcast();
  StreamSubscription<Object?>? _remoteSub;
  StreamSubscription<Object?>? _localSub;

  AuthRepositoryImpl({
    FirebaseAuthDataSource? remoteDataSource,
    FakeAuthDataSource? fakeDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _resolvedFake = fakeDataSource ?? FakeAuthDataSource() {
    _initStreams();
  }

  void _initStreams() {
    final remote = _remoteDataSource;
    if (remote != null) {
      _remoteSub = remote.authStateChanges.listen((remoteUser) {
        if (remoteUser != null) {
          _combinedAuthController.add(remoteUser.toDomain());
        } else if (_isFake && _resolvedFake.currentUser != null) {
          _combinedAuthController.add(_resolvedFake.currentUser!.toDomain());
        } else {
          _combinedAuthController.add(null);
        }
      }, onError: (_) {
        if (_isFake && _resolvedFake.currentUser != null) {
          _combinedAuthController.add(_resolvedFake.currentUser!.toDomain());
        } else {
          _combinedAuthController.add(null);
        }
      });
    }

    _localSub = _resolvedFake.authStateChanges.listen((localUser) {
      final remote = _remoteDataSource;
      if (remote != null && remote.currentUser != null) {
        _combinedAuthController.add(remote.currentUser!.toDomain());
      } else if (localUser != null) {
        _combinedAuthController.add(localUser.toDomain());
      } else {
        _combinedAuthController.add(null);
      }
    });
  }

  /// Libera suscripciones cuando el repositorio ya no se use
  void dispose() {
    _remoteSub?.cancel();
    _localSub?.cancel();
    _combinedAuthController.close();
  }

  bool get _isFake {
    if (!FirebaseInitializer.isInitialized ||
        !FirebaseConfig.hasCustomCredentials ||
        _remoteDataSource == null) {
      return true;
    }
    return false;
  }

  String _cleanError(Object e) {
    return e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  }

  @override
  Stream<UserEntity?> authStateChanges() async* {
    yield currentUser;
    yield* _combinedAuthController.stream;
  }

  @override
  UserEntity? get currentUser {
    final remote = _remoteDataSource?.currentUser?.toDomain();
    if (remote != null) return remote;
    return _resolvedFake.currentUser?.toDomain();
  }

  @override
  Future<Result<UserEntity, AppFailure>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
    String? department,
    String? photoUrl,
  }) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      return const FailureResult(
        ValidationFailure('Correo inválido', field: 'email'),
      );
    }
    if (password.length < 6) {
      return const FailureResult(
        ValidationFailure(
          'La contraseña debe tener al menos 6 caracteres',
          field: 'password',
        ),
      );
    }

    final remote = _remoteDataSource;
    // 1. Si Firebase está activo, intenta registrar en la nube
    if (!_isFake && remote != null) {
      try {
        final remoteUser = await remote.signUp(
          email: cleanEmail,
          password: password,
          displayName: displayName,
          department: department,
          photoUrl: photoUrl,
        );
        // Sincroniza también en local para soporte offline
        try {
          await _resolvedFake.signUp(
            email: cleanEmail,
            password: password,
            displayName: displayName,
            department: department,
            photoUrl: photoUrl,
          );
        } catch (_) {}

        final domainUser = remoteUser.toDomain();
        _combinedAuthController.add(domainUser);
        return Success(domainUser);
      } catch (remoteError) {
        final errLower = remoteError.toString().toLowerCase();

        // Errores de validación reales en Firebase
        if (errLower.contains('email-already-in-use') ||
            errLower.contains('este correo electrónico ya está registrado')) {
          return const FailureResult(
            AuthFailure('Este correo electrónico ya está registrado. Por favor inicia sesión.'),
          );
        }
        if (errLower.contains('weak-password')) {
          return const FailureResult(
            ValidationFailure('La contraseña debe tener al menos 6 caracteres', field: 'password'),
          );
        }

        // Si Firebase rechaza por configuración de consola (ej. operation-not-allowed),
        // falta de red o API key en propagación, creamos la cuenta en almacenamiento local
        // seguro para que el estudiante NUNCA se quede bloqueado.
        try {
          final fallbackUser = await _resolvedFake.signUp(
            email: cleanEmail,
            password: password,
            displayName: displayName,
            department: department,
            photoUrl: photoUrl,
          );
          final domainFallback = fallbackUser.toDomain();
          _combinedAuthController.add(domainFallback);
          return Success(domainFallback);
        } catch (localError) {
          return FailureResult(AuthFailure(_cleanError(localError)));
        }
      }
    }

    // 2. Si es fake o Firebase no está inicializado, registra localmente
    try {
      final userModel = await _resolvedFake.signUp(
        email: cleanEmail,
        password: password,
        displayName: displayName,
        department: department,
        photoUrl: photoUrl,
      );
      final domainUser = userModel.toDomain();
      _combinedAuthController.add(domainUser);
      return Success(domainUser);
    } catch (e) {
      return FailureResult(AuthFailure(_cleanError(e)));
    }
  }

  @override
  Future<Result<UserEntity, AppFailure>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      return const FailureResult(
        ValidationFailure('Correo inválido', field: 'email'),
      );
    }
    if (password.isEmpty) {
      return const FailureResult(
        ValidationFailure('Ingresa tu contraseña', field: 'password'),
      );
    }

    final remote = _remoteDataSource;
    // 1. Si Firebase está activo, intenta primero iniciar sesión en la nube
    if (!_isFake && remote != null) {
      try {
        final remoteUser = await remote.signIn(
          email: cleanEmail,
          password: password,
        );
        // Sincroniza localmente
        try {
          await _resolvedFake.signIn(email: cleanEmail, password: password);
        } catch (_) {}

        final domainUser = remoteUser.toDomain();
        _combinedAuthController.add(domainUser);
        return Success(domainUser);
      } catch (remoteError) {
        // Si Firebase no reconoce el usuario o el proveedor está pendiente de habilitar,
        // intentamos autenticar con el almacén local / provisión compasiva
        try {
          final localUser = await _resolvedFake.signIn(
            email: cleanEmail,
            password: password,
          );
          final domainLocal = localUser.toDomain();
          _combinedAuthController.add(domainLocal);
          return Success(domainLocal);
        } catch (localError) {
          return FailureResult(AuthFailure(_cleanError(localError)));
        }
      }
    }

    // 2. Si es fake, inicia sesión localmente
    try {
      final userModel = await _resolvedFake.signIn(
        email: cleanEmail,
        password: password,
      );
      final domainUser = userModel.toDomain();
      _combinedAuthController.add(domainUser);
      return Success(domainUser);
    } catch (e) {
      return FailureResult(AuthFailure(_cleanError(e)));
    }
  }

  @override
  Future<Result<void, AppFailure>> sendPasswordResetEmail(String email) async {
    final remote = _remoteDataSource;
    try {
      if (!_isFake && remote != null) {
        try {
          await remote.sendPasswordReset(email);
        } catch (_) {}
      }
      await _resolvedFake.sendPasswordReset(email);
      return const Success(null);
    } catch (e) {
      return FailureResult(AuthFailure(_cleanError(e)));
    }
  }

  @override
  Future<Result<void, AppFailure>> signOut() async {
    final remote = _remoteDataSource;
    try {
      await _resolvedFake.signOut();
      if (!_isFake && remote != null) {
        try {
          await remote.signOut();
        } catch (_) {}
      }
      _combinedAuthController.add(null);
      return const Success(null);
    } catch (e) {
      return FailureResult(AuthFailure(_cleanError(e)));
    }
  }

  @override
  Future<Result<void, AppFailure>> deleteAccount() async {
    final remote = _remoteDataSource;
    try {
      if (!_isFake && remote != null) {
        try {
          await remote.deleteAccount();
        } catch (_) {}
      }
      await _resolvedFake.deleteAccount();
      _combinedAuthController.add(null);
      return const Success(null);
    } catch (e) {
      return FailureResult(AuthFailure(_cleanError(e)));
    }
  }
}
