import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/firebase/firebase_config.dart';
import 'core/firebase/firebase_initializer.dart';
import 'core/services/notification_service.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/datasources/fake_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de notificaciones locales nativas y solicitud de permisos en Android 13/14
  await NotificationService.instance.initialize();
  await NotificationService.instance.requestPermission();

  // Restauración de sesión persistente local para que la cuenta no se cierre al salir de la app
  final prefs = await SharedPreferences.getInstance();
  final persistedUser = await FakeAuthDataSource.loadPersistedUser(prefs);

  // Inicialización segura de Firebase e infraestructura offline
  await FirebaseInitializer.initialize();

  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepositoryImpl(
            remoteDataSource: (FirebaseInitializer.isInitialized &&
                    FirebaseConfig.hasCustomCredentials)
                ? FirebaseAuthDataSource()
                : null,
            fakeDataSource: FakeAuthDataSource(persistedUser, prefs),
          ),
        ),
      ],
      child: const MindApp(),
    ),
  );
}
