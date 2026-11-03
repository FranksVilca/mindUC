/// Taxonomía de fallos de dominio para la aplicación mindUC.
sealed class AppFailure {
  final String message;

  const AppFailure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppFailure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => '$runtimeType: $message';
}

/// Fallo en operaciones de autenticación (credenciales inválidas, usuario no encontrado, etc.).
final class AuthFailure extends AppFailure {
  final String? code;

  const AuthFailure(super.message, {this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthFailure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => Object.hash(message, code);
}

/// Fallo en operaciones de red o conectividad.
final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Error de conexión. Verifica tu acceso a internet.']);
}

/// Fallo en servicios remotos o servidores de base de datos.
final class ServerFailure extends AppFailure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerFailure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode;

  @override
  int get hashCode => Object.hash(message, statusCode);
}

/// Fallo en almacenamiento local o caché del dispositivo.
final class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Error al acceder al almacenamiento local.']);
}

/// Fallo de validación de datos o formato (ej. correo fuera de dominio @uc.cl).
final class ValidationFailure extends AppFailure {
  final String field;

  const ValidationFailure(super.message, {required this.field});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationFailure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          field == other.field;

  @override
  int get hashCode => Object.hash(message, field);
}

