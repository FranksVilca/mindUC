import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/error/failures.dart';
import 'package:minduc/core/error/result.dart';

void main() {
  group('Result Monad & Failures Tests', () {
    test('Success returns true for isSuccess and provides data', () {
      const Result<String, AppFailure> result = Success('mindUC');

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, equals('mindUC'));
      expect(result.errorOrNull, isNull);

      final transformed = result.map((data) => data.toUpperCase());
      expect(transformed.dataOrNull, equals('MINDUC'));
    });

    test('FailureResult returns true for isFailure and provides error', () {
      const failure = AuthFailure('Credenciales incorrectas', code: 'user-not-found');
      const Result<String, AppFailure> result = FailureResult(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.errorOrNull, equals(failure));

      final matched = result.when(
        onSuccess: (data) => 'success',
        onFailure: (error) => error.message,
      );
      expect(matched, equals('Credenciales incorrectas'));
    });

    test('Failures equality and hash code work correctly', () {
      const f1 = AuthFailure('Error', code: 'invalid');
      const f2 = AuthFailure('Error', code: 'invalid');
      const f3 = AuthFailure('Otro error', code: 'invalid');

      expect(f1, equals(f2));
      expect(f1, isNot(equals(f3)));
      expect(f1.hashCode, equals(f2.hashCode));
    });
  });
}

