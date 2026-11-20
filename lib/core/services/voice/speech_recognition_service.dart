import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Proveedor del servicio de reconocimiento de voz
final speechRecognitionServiceProvider = Provider<SpeechRecognitionService>((ref) {
  return SpeechRecognitionServiceImpl();
});

/// Contrato abstracto para el servicio de reconocimiento de voz
abstract class SpeechRecognitionService {
  bool get isListening;
  bool get isAvailable;
  Future<bool> initialize();
  Future<bool> requestMicrophonePermission();
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    required void Function(String error) onError,
  });
  Future<void> stopListening();
  void dispose();
}

/// Implementación de reconocimiento de voz usando speech_to_text y permission_handler
class SpeechRecognitionServiceImpl implements SpeechRecognitionService {
  SpeechRecognitionServiceImpl({SpeechToText? speechToText})
      : _speechToText = speechToText ?? SpeechToText();

  final SpeechToText _speechToText;
  bool _isInitialized = false;

  @override
  bool get isListening => _speechToText.isListening;

  @override
  bool get isAvailable => _isInitialized && _speechToText.isAvailable;

  @override
  Future<bool> requestMicrophonePermission() async {
    try {
      if (kIsWeb) return true;
      final status = await Permission.microphone.status;
      if (status.isGranted) return true;
      final result = await Permission.microphone.request();
      return result.isGranted;
    } catch (e) {
      debugPrint('Error solicitando permisos de micrófono: $e');
      return false;
    }
  }

  @override
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      final hasPermission = await requestMicrophonePermission();
      if (!hasPermission) {
        return false;
      }

      _isInitialized = await _speechToText.initialize(
        onError: (SpeechRecognitionError error) {
          debugPrint('Error en SpeechToText: ${error.errorMsg}');
        },
        onStatus: (String status) {
          debugPrint('Estado SpeechToText: $status');
        },
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('Error inicializando SpeechToText: $e');
      _isInitialized = false;
      return false;
    }
  }

  @override
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    required void Function(String error) onError,
  }) async {
    try {
      final initialized = await initialize();
      if (!initialized) {
        onError('No se pudo inicializar el micrófono o faltan permisos.');
        return;
      }

      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          onResult(result.recognizedWords, result.finalResult);
        },
        listenOptions: SpeechListenOptions(
          localeId: 'es_CL',
          cancelOnError: false,
          partialResults: true,
          listenMode: ListenMode.confirmation,
        ),
      );
    } catch (e) {
      onError('Error al iniciar escucha: $e');
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      if (_speechToText.isListening) {
        await _speechToText.stop();
      }
    } catch (e) {
      debugPrint('Error deteniendo escucha: $e');
    }
  }

  @override
  void dispose() {
    try {
      _speechToText.cancel();
    } catch (_) {}
  }
}
