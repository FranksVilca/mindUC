import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/psychologist_message.dart';

/// Fuente de datos de IA para el orientador psicológico universitario de mindUC.
/// Utiliza Google Gemini API con systemInstruction clínico-educativo y motor de contingencia offline.
class GeminiPsychologistDataSource {
  GeminiPsychologistDataSource({
    String? apiKey,
    SharedPreferences? preferences,
  })  : _configuredApiKey = apiKey,
        _prefs = preferences;

  final String? _configuredApiKey;
  SharedPreferences? _prefs;
  GenerativeModel? _cachedModel;
  String? _lastUsedKey;

  static const String _prefApiKey = 'minduc_gemini_api_key';

  static const String _systemInstructionText = '''
Eres "MenteCalma", psicólogo orientador y especialista en salud mental universitaria de la aplicación mindUC.
Tu misión es brindar contención emocional empática, validación psicológica y recomendaciones prácticas de autorregulación para estudiantes que experimentan estrés académico, ansiedad, cansancio o dificultades de concentración.

MARCO CLÍNICO Y ÉTICO DE INTERVENCIÓN (Principio VII - Constitución de mindUC):
1. Rol Exclusivo: Actúa siempre desde la empatía incondicional, la psicología cognitivo-conductual (TCC) y el mindfulness. Jamás juzgues, minimices o desestimes lo que el estudiante expresa.
2. Alcance Ético: No eres un médico psiquiatra. No diagnostiques trastornos clínicos formales (como "padeces trastorno bipolar") ni recomiendes medicamentos.
3. Validación Emocional Primero: Antes de cualquier sugerencia, valida explícitamente lo que siente la persona (ej. "Entiendo perfectamente el peso que sientes; estudiar bajo tanta presión académica es agotador...").
4. Síntesis y Calidez: Responde en 2 o 3 párrafos breves, redactados en español cálido y cercano, adecuados para lectura ágil en un teléfono móvil.
5. Micro-Acción Práctica: Concluye siempre sugiriendo una herramienta concreta de la aplicación:
   - Respiración consciente (ej. Técnica 4-7-8 o Caja 4-4-4).
   - Pausa activa o estiramiento muscular (cuello, espalda, vista).
   - Escribir en el diario personal para vaciar la mente.
   - Un bloque de concentración Pomodoro sereno con sonidos de naturaleza.
6. Protocolo de Crisis: Si el usuario manifiesta ideación suicida, autolesiones o desesperanza severa, responde con máxima calidez y recomiéndale de inmediato contactar a la Línea de Apoyo Psicológico institucional o buscar ayuda médica presencial de urgencia.
7. Respuestas Fuera de Tema: Si el usuario pregunta cosas ajenas al bienestar emocional, estudio o salud mental (ej. programación, recetas, compras), declina con amabilidad recordando tu función como orientador de bienestar.
''';

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Obtiene la clave de API activa (de argumentos, SharedPreferences o entorno)
  Future<String?> getActiveApiKey() async {
    final configuredKey = _configuredApiKey?.trim();
    if (configuredKey != null && configuredKey.isNotEmpty) {
      return configuredKey;
    }
    const envKey = String.fromEnvironment('GEMINI_API_KEY');
    if (envKey.isNotEmpty) {
      return envKey;
    }
    final prefs = await _getPrefs();
    return prefs.getString(_prefApiKey);
  }

  /// Permite al estudiante o evaluador configurar su propia clave gratuita de Google AI Studio
  Future<void> saveCustomApiKey(String key) async {
    final prefs = await _getPrefs();
    if (key.trim().isEmpty) {
      await prefs.remove(_prefApiKey);
    } else {
      await prefs.setString(_prefApiKey, key.trim());
    }
    _cachedModel = null;
    _lastUsedKey = null;
  }

  Future<GenerativeModel?> _getModel() async {
    final key = await getActiveApiKey();
    if (key == null || key.isEmpty) {
      return null;
    }

    if (_cachedModel != null && _lastUsedKey == key) {
      return _cachedModel;
    }

    _lastUsedKey = key;
    _cachedModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: key,
      systemInstruction: Content.system(_systemInstructionText),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 400,
      ),
    );
    return _cachedModel;
  }

  /// Consulta al psicólogo IA y produce una respuesta con acción terapéutica sugerida
  Future<PsychologistMessage> askPsychologist({
    required String userMessage,
    String? currentMood,
    String? studentName,
    List<PsychologistMessage>? history,
  }) async {
    final model = await _getModel();

    if (model != null) {
      try {
        final promptBuffer = StringBuffer();
        if (studentName != null && studentName.isNotEmpty) {
          promptBuffer.writeln('Nombre del estudiante: $studentName');
        }
        if (currentMood != null && currentMood.isNotEmpty) {
          promptBuffer.writeln('Estado anímico actual registrado: $currentMood');
        }
        promptBuffer.writeln('Consulta o desahogo: $userMessage');

        // Construir historial reciente para mantener contexto de la conversación activa (ventana deslizante)
        final contents = <Content>[];
        if (history != null && history.isNotEmpty) {
          final recentHistory = history.length > 6
              ? history.sublist(history.length - 6)
              : history;
          for (final msg in recentHistory) {
            if (msg.isUser) {
              contents.add(Content.text(msg.text));
            } else {
              contents.add(Content.model([TextPart(msg.text)]));
            }
          }
        }
        contents.add(Content.text(promptBuffer.toString()));

        final response = await model.generateContent(contents);
        final replyText = response.text?.trim();

        if (replyText != null && replyText.isNotEmpty) {
          final action = _detectSuggestedAction(replyText);
          return PsychologistMessage(
            id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
            text: replyText,
            isUser: false,
            timestamp: DateTime.now(),
            actionType: action['type'],
            actionLabel: action['label'],
            actionRoute: action['route'],
          );
        }
      } catch (e) {
        debugPrint('Gemini API call notice, falling back to local psychologist engine: $e');
      }
    }

    // Motor de contingencia psicológico TCC offline de alta empatía
    return _generateEmpatheticFallback(userMessage, currentMood, studentName);
  }

  /// Genera saludo y orientación inicial personalizada según el estado de ánimo
  PsychologistMessage getInitialGreeting({
    String? studentName,
    String? currentMood,
  }) {
    final name = (studentName != null && studentName.isNotEmpty) ? studentName : 'estudiante';
    String intro;

    if (currentMood != null) {
      final moodLower = currentMood.toLowerCase();
      if (moodLower.contains('ansios') || moodLower.contains('estres')) {
        intro = 'Hola, $name. Noto que registraste que te sientes con ansiedad o tensión hoy. Recuerda que es completamente válido sentirlo cuando las exigencias universitarias se acumulan. Estoy aquí para acompañarte sin juicios.\n\n¿Qué es lo que más te está preocupando en este momento?';
      } else if (moodLower.contains('abrumad')) {
        intro = 'Hola, $name. Veo que te sientes abrumado/a hoy por las exigencias. Cuando las cosas se sienten abrumadoras, dar un paso atrás y pausar es el acto más compasivo.\n\nEstoy aquí contigo; cuéntame qué te tiene abrumado o si prefieres que tomemos una pausa guiada.';
      } else if (moodLower.contains('agotad') || moodLower.contains('cansa')) {
        intro = 'Hola, $name. Veo que tu energía está bajita hoy. Tu mente y tu cuerpo te están pidiendo una pausa amable. El descanso también es parte de tu formación académica.\n\nCuéntame, ¿sientes que es cansancio físico o saturación mental por el estudio?';
      } else if (moodLower.contains('trist')) {
        intro = 'Hola, $name. Siento que estés atravesando un día difícil. Abrazo este momento contigo; no tienes que fingir que todo está bien aquí.\n\nSi deseas desahogarte o simplemente reflexionar, este es un espacio seguro para ti.';
      } else {
        intro = 'Hola, $name. Soy MenteCalma, tu orientador de bienestar en mindUC 🌿. Este es tu espacio confidencial para cuidar tu mente, ordenar tus emociones y encontrar serenidad ante el ritmo universitario.\n\n¿En qué te gustaría que nos enfoquemos hoy?';
      }
    } else {
      intro = 'Hola, $name. Soy MenteCalma, tu orientador de bienestar en mindUC 🌿. Mi propósito es acompañarte con empatía, técnicas para la ansiedad académica y autorregulación serena.\n\n¿Cómo te sientes hoy o qué reto estás enfrentando?';
    }

    return PsychologistMessage(
      id: 'greeting_${DateTime.now().millisecondsSinceEpoch}',
      text: intro,
      isUser: false,
      timestamp: DateTime.now(),
      actionType: 'breathing',
      actionLabel: 'Hacer respiración consciente 🌿',
      actionRoute: AppRoutes.breathingSession,
    );
  }

  /// Detecta automáticamente el recurso de mindUC más relevante en la respuesta
  Map<String, String?> _detectSuggestedAction(String text) {
    final lower = text.toLowerCase();

    if (lower.contains('suicid') || lower.contains('autolesi') || lower.contains('urgencia')) {
      return {
        'type': 'support',
        'label': 'Línea de Apoyo Institucional 📞',
        'route': AppRoutes.profile,
      };
    }
    if (lower.contains('respir') || lower.contains('4-7-8') || lower.contains('inhal') || lower.contains('calma')) {
      return {
        'type': 'breathing',
        'label': 'Iniciar respiración 4-7-8 🌿',
        'route': AppRoutes.breathingSession,
      };
    }
    if (lower.contains('estiramient') || lower.contains('cuello') || lower.contains('pausa activa') || lower.contains('cuerpo')) {
      return {
        'type': 'relaxation',
        'label': 'Ver estiramientos guiados 🧘',
        'route': AppRoutes.relaxation,
      };
    }
    if (lower.contains('escrib') || lower.contains('diario') || lower.contains('pensamiento') || lower.contains('reflexion')) {
      return {
        'type': 'journal',
        'label': 'Escribir en mi diario íntimo 📝',
        'route': AppRoutes.journalNew,
      };
    }
    if (lower.contains('pomodoro') || lower.contains('concentra') || lower.contains('bloque') || lower.contains('procrastin')) {
      return {
        'type': 'pomodoro',
        'label': 'Iniciar bloque de concentración ⏱️',
        'route': AppRoutes.pomodoroSession,
      };
    }

    return {'type': null, 'label': null, 'route': null};
  }

  /// Motor clínico cognitivo-conductual offline
  PsychologistMessage _generateEmpatheticFallback(
    String userMessage,
    String? currentMood,
    String? studentName,
  ) {
    final lower = userMessage.toLowerCase();
    String response;
    String? actionType;
    String? actionLabel;
    String? actionRoute;

    if (lower.contains('suicid') ||
        lower.contains('morir') ||
        lower.contains('no quiero vivir') ||
        lower.contains('autolesi') ||
        lower.contains('desesperad')) {
      response = 'Escucho el dolor tan intenso que estás sintiendo y quiero que sepas que tu vida es valiosa y no tienes que llevar esto a solas. Por favor, comunícate de inmediato con la Línea de Apoyo Psicológico o acude a un servicio de urgencia presencial. Hay profesionales dispuestos a escucharte y cuidarte en este instante.';
      actionType = 'crisis_support';
      actionLabel = 'Línea de Apoyo Psicológico y Urgencias 📞';
      actionRoute = AppRoutes.community;
    } else if (lower.contains('examen') || lower.contains('prueba') || lower.contains('nota') || lower.contains('ansiedad')) {
      response = 'Es completamente comprensible sentir ansiedad ante las evaluaciones. La mente suele anticipar el peor de los escenarios cuando se preocupa por el rendimiento. Recuerda que una nota no define tu valor integral como persona ni tu capacidad intelectual.\n\nCuando sientas que la mente se acelera, ancla tu atención al presente con 3 respiraciones profundas: inhala en 4 segundos, retén 7 y exhala lentamente en 8. Eso enviará una señal directa a tu sistema nervioso de que estás a salvo.';
      actionType = 'breathing';
      actionLabel = 'Practicar respiración 4-7-8 ahora 🌿';
      actionRoute = AppRoutes.breathingSession;
    } else if (lower.contains('procrastin') || lower.contains('concentr') || lower.contains('empezar') || lower.contains('distra')) {
      response = 'La procrastinación no es pereza; desde la psicología sabemos que es un mecanismo de defensa contra el miedo al fracaso o la sensación de sobrecarga. Cuando la tarea parece inmensa, el cerebro prefiere evitarla.\n\nPrueba la regla de los "5 minutos amables": no te comprometas a terminar todo hoy, solo siéntate con un temporizador y avanza durante 5 minutos sin juzgar el resultado. Con frecuencia, dar el primer paso suave disuelve la resistencia.';
      actionType = 'pomodoro';
      actionLabel = 'Iniciar bloque de enfoque Pomodoro ⏱️';
      actionRoute = AppRoutes.pomodoroSession;
    } else if (lower.contains('cansad') || lower.contains('agotad') || lower.contains('sueno') || lower.contains('burnout')) {
      response = 'El cansancio acumulado es la forma en que tu cuerpo te pide una pausa compasiva. En la vida universitaria se premia la autoexigencia, pero nadie puede dar lo mejor de sí desde una vasija vacía.\n\nTe recomiendo desconectar de las pantallas durante 5 minutos, cerrar suavemente los ojos y realizar un estiramiento de cuello y hombros para liberar la tensión acumulada.';
      actionType = 'relaxation';
      actionLabel = 'Pausa activa de estiramientos 🧘';
      actionRoute = AppRoutes.relaxation;
    } else if (lower.contains('triste') || lower.contains('solo') || lower.contains('llorar') || lower.contains('nadie')) {
      response = 'Siento de corazón que estés experimentando esta tristeza y soledad. En la universidad es muy común compararse con los demás y creer que somos los únicos sufriendo, pero la vulnerabilidad es profundamente humana.\n\nPermítete sentir sin juzgarte. A veces plasmar en palabras lo que llevas dentro ayuda a aligerar el peso en el pecho.';
      actionType = 'journal';
      actionLabel = 'Desahogarme en el diario privado 📝';
      actionRoute = AppRoutes.journalNew;
    } else {
      response = 'Gracias por compartir esto conmigo. Todo lo que experimentas en tu trayectoria universitaria es valioso y merece ser escuchado. Recuerda darte permiso de avanzar a tu propio ritmo, un día a la vez.\n\n¿Te gustaría que hagamos un breve ejercicio de relajación o prefieres organizar una pausa consciente?';
      actionType = 'breathing';
      actionLabel = 'Hacer pausa de respiración consciente 🌿';
      actionRoute = AppRoutes.breathingSession;
    }

    return PsychologistMessage(
      id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
      actionType: actionType,
      actionLabel: actionLabel,
      actionRoute: actionRoute,
    );
  }
}
