import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_config.dart';
import 'firebase_options.dart';

/// Inicializador de infraestructura Firebase con soporte para persistencia
/// offline en Cloud Firestore y arranque seguro tolerante a fallos.
class FirebaseInitializer {
  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  /// Permite establecer el estado para pruebas unitarias o de integración
  @visibleForTesting
  static void setInitializedForTesting(bool value) {
    _initialized = value;
  }

  /// Inicializa Firebase y configura Cloud Firestore con persistencia offline.
  /// Si no se encuentran credenciales o no se puede conectar a los servicios,
  /// no arroja excepción para permitir la ejecución de tests y desarrollo UI
  /// con fallback automático a almacenamiento local seguro.
  static Future<void> initialize({FirebaseOptions? options}) async {
    if (_initialized) return;

    if (!FirebaseConfig.hasCustomCredentials && options == null) {
      debugPrint(
        '[FirebaseInitializer] Sin credenciales personalizadas de Firebase. Operando en modo local seguro offline-first.',
      );
      _initialized = false;
      return;
    }

    try {
      FirebaseOptions? targetOptions = options;
      try {
        targetOptions ??= DefaultFirebaseOptions.currentPlatform;
      } catch (_) {
        targetOptions = null;
      }

      if (targetOptions != null) {
        await Firebase.initializeApp(options: targetOptions);
      } else {
        await Firebase.initializeApp();
      }

      // Configuración de persistencia offline ilimitada para Cloud Firestore
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _initialized = true;
      FirebaseConfig.printStatus();
      debugPrint(
        '[FirebaseInitializer] Firebase y Firestore inicializados correctamente (Offline-First).',
      );
    } catch (e) {
      debugPrint(
        '[FirebaseInitializer] Aviso: Firebase arrancando con respaldo local/mock: $e',
      );
      _initialized = false;
    }
  }
}
