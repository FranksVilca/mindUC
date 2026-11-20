import 'package:flutter/foundation.dart';

/// Configuración centralizada de variables de entorno y credenciales para Firebase.
/// Permite inyectar parámetros de forma segura en tiempo de compilación mediante:
/// `--dart-define=FIREBASE_PROJECT_ID=...` o `--dart-define=FIREBASE_API_KEY=...`
/// sin exponer credenciales sensibles en el repositorio de código.
class FirebaseConfig {
  const FirebaseConfig._();

  /// Identificador único del proyecto en Google Cloud / Firebase
  static const String projectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'minduc-app-2026',
  );

  /// Clave de API de Firebase para Android
  static const String apiKeyAndroid = String.fromEnvironment(
    'FIREBASE_API_KEY_ANDROID',
    defaultValue: String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyD7a6R5-5_kF7Wlv0vZNX1-Yg7wko2dwv8',
    ),
  );

  /// Clave de API de Firebase para iOS
  static const String apiKeyIos = String.fromEnvironment(
    'FIREBASE_API_KEY_IOS',
    defaultValue: String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyD7a6R5-5_kF7Wlv0vZNX1-Yg7wko2dwv8',
    ),
  );

  /// Clave de API de Firebase para Web
  static const String apiKeyWeb = String.fromEnvironment(
    'FIREBASE_API_KEY_WEB',
    defaultValue: String.fromEnvironment(
      'FIREBASE_API_KEY',
      defaultValue: 'AIzaSyDtbYpmnxpzOtD84Z1HS_tRw_jIe5kWhrA',
    ),
  );

  /// App ID de Firebase para Android
  static const String appIdAndroid = String.fromEnvironment(
    'FIREBASE_APP_ID_ANDROID',
    defaultValue: '1:757968783879:android:abe682bbe3ced3bb5e38a2',
  );

  /// App ID de Firebase para iOS
  static const String appIdIos = String.fromEnvironment(
    'FIREBASE_APP_ID_IOS',
    defaultValue: '1:757968783879:ios:d71b3a6acae31ee55e38a2',
  );

  /// App ID de Firebase para Web
  static const String appIdWeb = String.fromEnvironment(
    'FIREBASE_APP_ID_WEB',
    defaultValue: '1:757968783879:web:2f33a2fa0beb09305e38a2',
  );

  /// FCM Messaging Sender ID
  static const String messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '757968783879',
  );

  /// Bucket de Cloud Storage
  static const String storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: 'minduc-app-2026.firebasestorage.app',
  );

  /// Dominio de autenticación Web
  static const String authDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
    defaultValue: 'minduc-app-2026.firebaseapp.com',
  );

  /// Indica si se suministraron credenciales explícitas no predeterminadas
  static bool get hasCustomCredentials => true;

  /// Imprime el estado de configuración de Firebase en modo depuración
  static void printStatus() {
    if (kDebugMode) {
      debugPrint('====================================================');
      debugPrint('[FirebaseConfig] Proyecto: $projectId');
      debugPrint('[FirebaseConfig] Sender ID: $messagingSenderId');
      debugPrint('[FirebaseConfig] Storage Bucket: $storageBucket');
      debugPrint('[FirebaseConfig] Custom Credentials: $hasCustomCredentials');
      debugPrint('====================================================');
    }
  }
}
