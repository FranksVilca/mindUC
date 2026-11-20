import 'package:flutter/material.dart';
import '../entities/agenda_category.dart';

/// Resultado del análisis e interpretación de comandos de voz para la agenda.
class ParsedVoiceActivity {
  final String title;
  final String subtitle;
  final DateTime scheduledDate;
  final TimeOfDay scheduledTime;
  final AgendaCategory category;
  final String rawTranscript;

  const ParsedVoiceActivity({
    required this.title,
    this.subtitle = '',
    required this.scheduledDate,
    required this.scheduledTime,
    required this.category,
    required this.rawTranscript,
  });

  /// Combina la fecha y la hora en un único objeto DateTime.
  DateTime get fullScheduledDateTime => DateTime(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );
}

/// Analizador inteligente de texto en español para extraer intenciones de agenda por voz.
class VoiceActivityParser {
  /// Analiza una transcripción por voz y extrae título, descripción, fecha, hora y categoría.
  static ParsedVoiceActivity parse(
    String transcript, {
    DateTime? referenceDate,
    TimeOfDay? defaultTime,
  }) {
    final now = referenceDate ?? DateTime.now();
    final cleanInput = transcript.trim();
    final lower = cleanInput.toLowerCase();

    // 1. Extraer categoría
    final category = _extractCategory(lower);

    // 2. Extraer fecha
    final (extractedDate, dateMatchPatterns) = _extractDate(lower, now);

    // 3. Extraer hora
    final (extractedTime, timeMatchPatterns) =
        _extractTime(lower, defaultTime ?? TimeOfDay.fromDateTime(now));

    // 4. Limpiar título removiendo indicadores de tiempo y preposiciones
    String title = cleanInput;
    for (final pattern in [...dateMatchPatterns, ...timeMatchPatterns]) {
      title = title.replaceAll(RegExp(pattern, caseSensitive: false), ' ');
    }

    // Limpieza de palabras conectoras al inicio y final
    title = title
        .replaceAll(
          RegExp(r'\b(agendar|agregar|crear|programar|anotar|recordar)\b',
              caseSensitive: false),
          '',
        )
        .replaceAll(
          RegExp(r'\b(para|el|la|los|las|a|en|de)\s*$', caseSensitive: false),
          '',
        )
        .replaceAll(
          RegExp(r'^\s*\b(para|el|la|los|las|a|en|de)\b\s*', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (title.isEmpty) {
      title = cleanInput;
    }

    // Capitalizar primera letra
    if (title.isNotEmpty) {
      title = title[0].toUpperCase() + title.substring(1);
    }

    return ParsedVoiceActivity(
      title: title,
      subtitle: 'Comando de voz: "$cleanInput"',
      scheduledDate: extractedDate,
      scheduledTime: extractedTime,
      category: category,
      rawTranscript: cleanInput,
    );
  }

  static AgendaCategory _extractCategory(String lower) {
    if (lower.contains('estudi') ||
        lower.contains('cálculo') ||
        lower.contains('calculo') ||
        lower.contains('examen') ||
        lower.contains('prueba') ||
        lower.contains('tarea') ||
        lower.contains('trabajo') ||
        lower.contains('clase') ||
        lower.contains('ayudant') ||
        lower.contains('laboratorio') ||
        lower.contains('tesis') ||
        lower.contains('informe') ||
        lower.contains('proyecto')) {
      return AgendaCategory.estudioTrabajo;
    }

    if (lower.contains('psicól') ||
        lower.contains('psicol') ||
        lower.contains('terapia') ||
        lower.contains('ansiedad') ||
        lower.contains('emocion') ||
        lower.contains('salud mental') ||
        lower.contains('desahogo') ||
        lower.contains('angustia') ||
        lower.contains('apoyo')) {
      return AgendaCategory.saludMental;
    }

    // Por defecto autocuidado (respiración, pausa, meditación, paseo, descanso, etc.)
    return AgendaCategory.autocuidado;
  }

  static (DateTime, List<String>) _extractDate(String lower, DateTime now) {
    final patterns = <String>[];

    // Hoy
    if (RegExp(r'\bhoy\b').hasMatch(lower)) {
      patterns.add(r'\b(de\s+)?hoy\b');
      return (DateTime(now.year, now.month, now.day), patterns);
    }

    // Pasado mañana
    if (RegExp(r'\bpasado\s+mañana\b').hasMatch(lower)) {
      patterns.add(r'\b(para\s+)?pasado\s+mañana\b');
      final target = now.add(const Duration(days: 2));
      return (DateTime(target.year, target.month, target.day), patterns);
    }

    // Mañana
    if (RegExp(r'\bmañana\b').hasMatch(lower)) {
      patterns.add(r'\b(para\s+)?mañana\b');
      final target = now.add(const Duration(days: 1));
      return (DateTime(target.year, target.month, target.day), patterns);
    }

    // Días de la semana en español
    final weekDaysMap = {
      'lunes': DateTime.monday,
      'martes': DateTime.tuesday,
      'miércoles': DateTime.wednesday,
      'miercoles': DateTime.wednesday,
      'jueves': DateTime.thursday,
      'viernes': DateTime.friday,
      'sábado': DateTime.saturday,
      'sabado': DateTime.saturday,
      'domingo': DateTime.sunday,
    };

    for (final entry in weekDaysMap.entries) {
      final dayRegex = RegExp(r'\b(el\s+)?(próximo\s+|proximo\s+)?' + entry.key + r'\b');
      if (dayRegex.hasMatch(lower)) {
        patterns.add(r'\b(el\s+)?(próximo\s+|proximo\s+)?' + entry.key + r'\b');
        int daysToAdd = (entry.value - now.weekday) % 7;
        if (daysToAdd <= 0) daysToAdd += 7;
        final target = now.add(Duration(days: daysToAdd));
        return (DateTime(target.year, target.month, target.day), patterns);
      }
    }

    // Fechas explícitas: "el 24 de octubre", "25 de noviembre"
    final monthsMap = {
      'enero': 1,
      'febrero': 2,
      'marzo': 3,
      'abril': 4,
      'mayo': 5,
      'junio': 6,
      'julio': 7,
      'agosto': 8,
      'septiembre': 9,
      'octubre': 10,
      'noviembre': 11,
      'diciembre': 12,
    };

    for (final entry in monthsMap.entries) {
      final monthRegex = RegExp(
        r'\b(?:el\s+)?(\d{1,2})\s+de\s+' + entry.key + r'(?:\s+de\s+(\d{4}))?\b',
      );
      final match = monthRegex.firstMatch(lower);
      if (match != null) {
        patterns.add(match.group(0)!);
        final day = int.parse(match.group(1)!);
        final year = match.group(2) != null ? int.parse(match.group(2)!) : now.year;
        return (DateTime(year, entry.value, day), patterns);
      }
    }

    return (DateTime(now.year, now.month, now.day), patterns);
  }

  static (TimeOfDay, List<String>) _extractTime(
      String lower, TimeOfDay defaultTime) {
    final patterns = <String>[];

    // 1. Formato "a las HH:MM" o "HH:MM"
    final regexClock = RegExp(
        r'\b(?:a\s+las\s+)?(\d{1,2}):(\d{2})(?:\s*(am|pm|de la mañana|de la tarde|de la noche))?\b');
    final matchClock = regexClock.firstMatch(lower);
    if (matchClock != null) {
      patterns.add(matchClock.group(0)!);
      var hour = int.parse(matchClock.group(1)!);
      final minute = int.parse(matchClock.group(2)!);
      final period = matchClock.group(3)?.toLowerCase() ?? '';

      if ((period.contains('pm') ||
              period.contains('tarde') ||
              period.contains('noche')) &&
          hour < 12) {
        hour += 12;
      } else if (period.contains('am') && hour == 12) {
        hour = 0;
      }
      return (TimeOfDay(hour: hour, minute: minute), patterns);
    }

    // 2. Formato "a las H y media" o "a las H y cuarto"
    final regexWordMin = RegExp(
        r'\b(?:a\s+las\s+)?(\d{1,2})\s+y\s+(media|cuarto)(?:\s*(am|pm|de la mañana|de la tarde|de la noche))?\b');
    final matchWordMin = regexWordMin.firstMatch(lower);
    if (matchWordMin != null) {
      patterns.add(matchWordMin.group(0)!);
      var hour = int.parse(matchWordMin.group(1)!);
      final minute = matchWordMin.group(2) == 'media' ? 30 : 15;
      final period = matchWordMin.group(3)?.toLowerCase() ?? '';

      if ((period.contains('pm') ||
              period.contains('tarde') ||
              period.contains('noche')) &&
          hour < 12) {
        hour += 12;
      }
      return (TimeOfDay(hour: hour, minute: minute), patterns);
    }

    // 3. Formato "a las H [am/pm/de la tarde/mañana]"
    final regexHour = RegExp(
        r'\b(?:a\s+las\s+)?(\d{1,2})(?:\s*(am|pm|de la mañana|de la tarde|de la noche))\b');
    final matchHour = regexHour.firstMatch(lower);
    if (matchHour != null) {
      patterns.add(matchHour.group(0)!);
      var hour = int.parse(matchHour.group(1)!);
      final period = matchHour.group(2)!.toLowerCase();

      if ((period.contains('pm') ||
              period.contains('tarde') ||
              period.contains('noche')) &&
          hour < 12) {
        hour += 12;
      } else if (period.contains('am') && hour == 12) {
        hour = 0;
      }
      return (TimeOfDay(hour: hour, minute: 0), patterns);
    }

    // 4. Formato simple "a las H"
    final regexSimpleHour = RegExp(r'\ba\s+las\s+(\d{1,2})\b');
    final matchSimple = regexSimpleHour.firstMatch(lower);
    if (matchSimple != null) {
      patterns.add(matchSimple.group(0)!);
      var hour = int.parse(matchSimple.group(1)!);
      // Heurística de horario universitario (si es 1 a 6, suele ser de la tarde)
      if (hour >= 1 && hour <= 6) {
        hour += 12;
      }
      return (TimeOfDay(hour: hour, minute: 0), patterns);
    }

    // 5. Palabras clave: mediodía
    if (RegExp(r'\b(al\s+)?mediod[ií]a\b').hasMatch(lower)) {
      patterns.add(r'\b(al\s+)?mediod[ií]a\b');
      return (const TimeOfDay(hour: 12, minute: 0), patterns);
    }

    return (defaultTime, patterns);
  }
}
