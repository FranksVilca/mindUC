import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/utils/date_formatter.dart';

void main() {
  group('SpanishDateFormatter Unit Tests', () {
    test('formats Thursday Oct 24 correctly', () {
      final testDate = DateTime(2024, 10, 24); // Oct 24, 2024 was Thursday
      expect(SpanishDateFormatter.format(testDate), equals('Jueves, 24 de Octubre'));
    });

    test('formats start of year and end of year correctly', () {
      final jan1 = DateTime(2026, 1, 1); // Thursday
      expect(SpanishDateFormatter.format(jan1), equals('Jueves, 1 de Enero'));

      final dec31 = DateTime(2026, 12, 31); // Thursday
      expect(SpanishDateFormatter.format(dec31), equals('Jueves, 31 de Diciembre'));
    });

    test('converts date to ISO YYYY-MM-DD string with padding', () {
      final date = DateTime(2026, 4, 9);
      expect(SpanishDateFormatter.toIsoDateString(date), equals('2026-04-09'));
    });
  });
}
