/// Mónada funcional para encapsular resultados exitosos o fallos tipados
/// evitando el lanzamiento de excepciones no controladas.
sealed class Result<T, E> {
  const Result();

  /// Retorna `true` si el resultado es exitoso ([Success]).
  bool get isSuccess => this is Success<T, E>;

  /// Retorna `true` si el resultado representa un fallo ([FailureResult]).
  bool get isFailure => this is FailureResult<T, E>;

  /// Obtiene los datos en caso de éxito, o `null` si es fallo.
  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        FailureResult() => null,
      };

  /// Obtiene el error en caso de fallo, o `null` si es éxito.
  E? get errorOrNull => switch (this) {
        Success() => null,
        FailureResult(:final error) => error,
      };

  /// Aplica [onSuccess] o [onFailure] según el estado del resultado.
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(E error) onFailure,
  }) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      FailureResult(:final error) => onFailure(error),
    };
  }

  /// Mapea el valor de éxito preservando el tipo de error.
  Result<R, E> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Success(transform(data)),
      FailureResult(:final error) => FailureResult(error),
    };
  }
}

/// Representa un resultado exitoso que contiene datos de tipo [T].
final class Success<T, E> extends Result<T, E> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T, E> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Representa un resultado fallido que contiene un error de tipo [E].
final class FailureResult<T, E> extends Result<T, E> {
  final E error;

  const FailureResult(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureResult<T, E> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'FailureResult($error)';
}
