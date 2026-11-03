import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/failures.dart';
import '../error/result.dart';

/// Servicio de almacenamiento seguro para claves criptográficas,
/// tokens de sesión y datos confidenciales.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  Future<Result<void, CacheFailure>> write({
    required String key,
    required String value,
  }) async {
    try {
      await _storage.write(key: key, value: value);
      return const Success(null);
    } catch (e) {
      return CacheFailure('Fallo al escribir clave segura: $e').asFailure();
    }
  }

  Future<Result<String?, CacheFailure>> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      return Success(value);
    } catch (e) {
      return CacheFailure('Fallo al leer clave segura: $e').asFailure();
    }
  }

  Future<Result<void, CacheFailure>> delete(String key) async {
    try {
      await _storage.delete(key: key);
      return const Success(null);
    } catch (e) {
      return CacheFailure('Fallo al eliminar clave segura: $e').asFailure();
    }
  }

  Future<Result<void, CacheFailure>> deleteAll() async {
    try {
      await _storage.deleteAll();
      return const Success(null);
    } catch (e) {
      return CacheFailure('Fallo al vaciar almacenamiento seguro: $e').asFailure();
    }
  }
}

extension AppFailureResultExtension<F extends AppFailure> on F {
  Result<T, F> asFailure<T>() => FailureResult<T, F>(this);
}
