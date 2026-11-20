/// Tipo de violación detectada por el moderador de contenidos del foro.
enum ModerationViolationReason {
  empty,
  personalData,
  profanity,
}

/// Resultado inmutable de la evaluación de moderación.
class ContentModerationResult {
  final bool isValid;
  final String? blockedWord;
  final ModerationViolationReason? reason;
  final String? message;

  const ContentModerationResult.valid()
      : isValid = true,
        blockedWord = null,
        reason = null,
        message = null;

  const ContentModerationResult.invalid({
    required this.reason,
    required this.message,
    this.blockedWord,
  }) : isValid = false;
}

/// Servicio de dominio para moderación de contenido, listas negras y protección
/// de convivencia en el foro comunitario y comentarios (Principios IV y V).
class CommunityContentModerator {
  CommunityContentModerator._();

  /// Expresión regular para detectar correos y datos de contacto personales.
  static final RegExp _emailRegex =
      RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');

  /// Catálogo base de palabras y expresiones prohibidas (insultos, agresiones,
  /// amenazas, lenguaje de odio y términos denigrantes).
  static const List<String> defaultBannedWords = [
    // Agresiones severas e incitación al daño
    'matate',
    'matarte',
    'muerete',
    'mueras',
    'muera',
    'morite',
    'morirte',
    'suicidate',
    'suicidarte',
    'suicidarse',
    'suicidio',

    // Insultos comunes en Chile y Latinoamérica
    'conchetumadre',
    'conchatumadre',
    'concha de tu madre',
    'chucha',
    'ctm',
    'weon',
    'weona',
    'weones',
    'aweonao',
    'aweonada',
    'huevon',
    'huevona',
    'huevones',
    'ahuevao',
    'culiao',
    'culia',
    'culiado',
    'culiada',
    'ql',
    'qla',
    'pendejo',
    'pendeja',
    'pendejos',
    'mierda',
    'mierdas',
    'puta',
    'puto',
    'putas',
    'putos',
    'hijo de puta',
    'hija de puta',
    'hdp',
    'bastardo',
    'bastarda',
    'cabron',
    'cabrona',
    'cabrones',
    'estupido',
    'estupida',
    'estupidos',
    'idiota',
    'idiotas',
    'imbecil',
    'imbeciles',
    'maricon',
    'marica',
    'maricones',
    'tarado',
    'tarada',
    'maldito',
    'maldita',
    'zorra',
    'perra',
    'pelotudo',
    'pelotuda',
    'gil',
  ];

  /// Patrones precompilados estáticos para evitar recompilación en tiempo de ejecución.
  static final List<({String word, RegExp pattern})> _compiledPatterns =
      defaultBannedWords
          .where((w) => !w.contains(' '))
          .map((word) {
            final charPatterns =
                word.split('').map((c) => '${RegExp.escape(c)}+').toList();
            final spacedPattern = charPatterns.join(r'[\s._\-*]*');
            final pattern = RegExp(
              r'(^|[^\w])' + spacedPattern + r'([^\w]|$)',
              caseSensitive: false,
            );
            return (word: word, pattern: pattern);
          })
          .toList(growable: false);

  /// Expresiones regulares precompiladas para enmascaramiento con asteriscos.
  static final List<RegExp> _maskPatterns = defaultBannedWords.map((word) {
    final escaped = RegExp.escape(word);
    return RegExp(r'\b' + escaped + r'\b', caseSensitive: false);
  }).toList(growable: false);

  /// Normaliza una cadena para comparación:
  /// - Minúsculas.
  /// - Reemplazo de leetspeak (@ -> a, 3 -> e, 1/! -> i, 0 -> o, $ -> s, etc.).
  /// - Eliminación de tildes/acentos.
  /// - Colapso de caracteres repetidos excesivos (ej: "puuuuta" -> "puta").
  static String normalizeText(String input) {
    var text = input.toLowerCase();

    // Reemplazo de caracteres leetspeak comunes
    text = text
        .replaceAll('@', 'a')
        .replaceAll('4', 'a')
        .replaceAll('3', 'e')
        .replaceAll('1', 'i')
        .replaceAll('!', 'i')
        .replaceAll('0', 'o')
        .replaceAll('\$', 's')
        .replaceAll('5', 's')
        .replaceAll('7', 't');

    // Eliminación de acentos y diacríticos
    const withAccents = 'áéíóúüàèìòù';
    const withoutAccents = 'aeiouuaeiou';
    for (var i = 0; i < withAccents.length; i++) {
      text = text.replaceAll(withAccents[i], withoutAccents[i]);
    }

    return text;
  }

  /// Evalúa el contenido y retorna un [ContentModerationResult].
  static ContentModerationResult validate(String rawText) {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      return const ContentModerationResult.invalid(
        reason: ModerationViolationReason.empty,
        message: 'Por favor escribe tu reflexión antes de publicar.',
      );
    }

    // 1. Detección de correos o datos de contacto personales (Principio V)
    if (_emailRegex.hasMatch(trimmed) || trimmed.contains('@uc.cl')) {
      return const ContentModerationResult.invalid(
        reason: ModerationViolationReason.personalData,
        message:
            'Por tu privacidad, no incluyas correos ni datos personales en tu mensaje 🛡',
      );
    }

    // 2. Normalización de texto para detección de palabras prohibidas
    final normalized = normalizeText(trimmed);

    // Detección de expresiones compuestas primero (ej. "concha de tu madre", "hijo de puta")
    final multiWordPhrases = [
      'concha de tu madre',
      'hijo de puta',
      'hija de puta',
    ];
    for (final phrase in multiWordPhrases) {
      if (normalized.contains(phrase)) {
        return ContentModerationResult.invalid(
          reason: ModerationViolationReason.profanity,
          blockedWord: phrase,
          message:
              'Tu mensaje contiene expresiones no permitidas ("$phrase"). Cuidemos el respeto y la calidez en el foro 🌿',
        );
      }
    }

    // Detección de palabras individuales mediante expresiones regulares precompiladas
    for (final entry in _compiledPatterns) {
      if (entry.pattern.hasMatch(normalized)) {
        return ContentModerationResult.invalid(
          reason: ModerationViolationReason.profanity,
          blockedWord: entry.word,
          message:
              'Tu mensaje contiene palabras no permitidas ("${entry.word}"). Cuidemos el respeto y la calidez en el foro 🌿',
        );
      }
    }

    return const ContentModerationResult.valid();
  }

  /// Retorna `true` si el texto pasa todas las reglas de moderación.
  static bool isClean(String text) => validate(text).isValid;

  /// Máscara opcional para reemplazar palabras prohibidas con asteriscos.
  static String maskBannedWords(String input) {
    var result = input;
    for (final pattern in _maskPatterns) {
      result = result.replaceAllMapped(pattern, (match) {
        return '*' * match.group(0)!.length;
      });
    }
    return result;
  }
}
