import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_category.dart';
import 'package:minduc/features/agenda/domain/services/voice_activity_parser.dart';

void main() {
  group('VoiceActivityParser Unit Tests', () {
    final referenceDate = DateTime(2024, 10, 24, 10, 0); // Jueves 24 Octubre 2024

    test('Parsea actividad de estudio para mañana en la tarde', () {
      final result = VoiceActivityParser.parse(
        'Estudiar para el examen de cálculo mañana a las 3 de la tarde',
        referenceDate: referenceDate,
      );

      expect(result.title.toLowerCase(), contains('estudiar para el examen de cálculo'));
      expect(result.category, AgendaCategory.estudioTrabajo);
      expect(result.scheduledDate.year, 2024);
      expect(result.scheduledDate.month, 10);
      expect(result.scheduledDate.day, 25); // Mañana
      expect(result.scheduledTime.hour, 15); // 3 de la tarde
      expect(result.scheduledTime.minute, 0);
    });

    test('Parsea actividad de salud mental con día de la semana', () {
      final result = VoiceActivityParser.parse(
        'Sesión con la psicóloga el viernes a las 10:30 am',
        referenceDate: referenceDate,
      );

      expect(result.title.toLowerCase(), contains('sesión con la psicóloga'));
      expect(result.category, AgendaCategory.saludMental);
      expect(result.scheduledDate.year, 2024);
      expect(result.scheduledDate.month, 10);
      expect(result.scheduledDate.day, 25); // Viernes 25
      expect(result.scheduledTime.hour, 10);
      expect(result.scheduledTime.minute, 30);
    });

    test('Parsea actividad de autocuidado para hoy', () {
      final result = VoiceActivityParser.parse(
        'Meditación guiada y respiración hoy a las 8 de la mañana',
        referenceDate: referenceDate,
      );

      expect(result.title.toLowerCase(), contains('meditación guiada y respiración'));
      expect(result.category, AgendaCategory.autocuidado);
      expect(result.scheduledDate.day, 24); // Hoy
      expect(result.scheduledTime.hour, 8);
      expect(result.scheduledTime.minute, 0);
    });

    test('Parsea fecha explícita con mes en español', () {
      final result = VoiceActivityParser.parse(
        'Entregar informe de laboratorio el 28 de octubre a las 18:00',
        referenceDate: referenceDate,
      );

      expect(result.category, AgendaCategory.estudioTrabajo);
      expect(result.scheduledDate.year, 2024);
      expect(result.scheduledDate.month, 10);
      expect(result.scheduledDate.day, 28);
      expect(result.scheduledTime.hour, 18);
      expect(result.scheduledTime.minute, 0);
    });

    test('Usa valores por defecto cuando no se menciona fecha u hora', () {
      const defaultTime = TimeOfDay(hour: 11, minute: 0);
      final result = VoiceActivityParser.parse(
        'Pausa activa y estiramiento',
        referenceDate: referenceDate,
        defaultTime: defaultTime,
      );

      expect(result.title, 'Pausa activa y estiramiento');
      expect(result.category, AgendaCategory.autocuidado);
      expect(result.scheduledDate.day, 24);
      expect(result.scheduledTime.hour, 11);
    });
  });
}
