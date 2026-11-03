import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Inicializador de infraestructura Firebase con soporte para persistencia
/// offline en Cloud Firestore y arranque seguro tolerante a fallos.
class FirebaseInitializer {
  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  /// Inicializa Firebase y configura Cloud Firestore con persistencia offline.
  /// Si no se encuentran credenciales (ej. mock local o CI), no arroja excepción
  /// para permitir la ejecución de tests y desarrollo UI.
  static Future<void> initialize({FirebaseOptions? options}) async {
    if (_initialized) return;

    try {
      if (options != null) {
        await Firebase.initializeApp(options: options);
      } else {
        await Firebase.initializeApp();
      }

      // Configuración de persistencia offline para Cloud Firestore
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _initialized = true;
      debugPrint('[FirebaseInitializer] Firebase y Firestore inicializados correctamente (Offline-First).');
    } catch (e) {
      debugPrint('[FirebaseInitializer] Aviso: Firebase arrancando en modo sin conexión/mock: $e');
      _initialized = false;
    }
  }
}

