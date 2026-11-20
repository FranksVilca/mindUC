import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'firebase_config.dart';

/// Opciones de configuración de Firebase por plataforma para mindUC.
/// Basado en el estándar oficial de FlutterFire CLI y desacoplado mediante
/// variables de entorno protegidas en [FirebaseConfig].
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: FirebaseConfig.apiKeyWeb,
    appId: FirebaseConfig.appIdWeb,
    messagingSenderId: FirebaseConfig.messagingSenderId,
    projectId: FirebaseConfig.projectId,
    authDomain: FirebaseConfig.authDomain,
    storageBucket: FirebaseConfig.storageBucket,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: FirebaseConfig.apiKeyAndroid,
    appId: FirebaseConfig.appIdAndroid,
    messagingSenderId: FirebaseConfig.messagingSenderId,
    projectId: FirebaseConfig.projectId,
    storageBucket: FirebaseConfig.storageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: FirebaseConfig.apiKeyIos,
    appId: FirebaseConfig.appIdIos,
    messagingSenderId: FirebaseConfig.messagingSenderId,
    projectId: FirebaseConfig.projectId,
    storageBucket: FirebaseConfig.storageBucket,
    iosBundleId: 'com.minduc.minduc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: FirebaseConfig.apiKeyIos,
    appId: FirebaseConfig.appIdIos,
    messagingSenderId: FirebaseConfig.messagingSenderId,
    projectId: FirebaseConfig.projectId,
    storageBucket: FirebaseConfig.storageBucket,
    iosBundleId: 'com.minduc.minduc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: FirebaseConfig.apiKeyWeb,
    appId: FirebaseConfig.appIdWeb,
    messagingSenderId: FirebaseConfig.messagingSenderId,
    projectId: FirebaseConfig.projectId,
    authDomain: FirebaseConfig.authDomain,
    storageBucket: FirebaseConfig.storageBucket,
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: FirebaseConfig.apiKeyWeb,
    appId: FirebaseConfig.appIdWeb,
    messagingSenderId: FirebaseConfig.messagingSenderId,
    projectId: FirebaseConfig.projectId,
    authDomain: FirebaseConfig.authDomain,
    storageBucket: FirebaseConfig.storageBucket,
  );
}
