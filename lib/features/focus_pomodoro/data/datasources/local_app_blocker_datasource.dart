import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_blocker_status.dart';
import '../../domain/entities/blocked_app.dart';

/// Fuente de datos local para la gestión de bloqueo de aplicaciones y permisos de sistema.
class LocalAppBlockerDatasource {
  LocalAppBlockerDatasource({SharedPreferences? preferences})
      : _prefs = preferences;

  SharedPreferences? _prefs;
  static List<AppInfo>? _cachedInstalledAppsRaw;
  static const MethodChannel _channel =
      MethodChannel('com.minduc.minduc/app_blocker');

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Resuelve nombres comunes o paquetes personalizados a su identificador canónico de Android.
  static String resolveCanonicalPackage(String pkg, String name) {
    final lowerPkg = pkg.toLowerCase();
    final lowerName = name.toLowerCase().trim();
    if (lowerPkg.contains('instagram') || lowerName == 'instagram') {
      return 'com.instagram.android';
    }
    if (lowerPkg.contains('tiktok') ||
        lowerPkg.contains('musically') ||
        lowerName == 'tiktok') {
      return 'com.zhiliaoapp.musically';
    }
    if (lowerPkg.contains('whatsapp') || lowerName == 'whatsapp') {
      return 'com.whatsapp';
    }
    if (lowerPkg.contains('youtube') || lowerName == 'youtube') {
      return 'com.google.android.youtube';
    }
    if (lowerPkg.contains('facebook') ||
        lowerPkg.contains('katana') ||
        lowerName == 'facebook') {
      return 'com.facebook.katana';
    }
    if (lowerPkg.contains('aliexpress') || lowerName == 'aliexpress') {
      return 'com.alibaba.aliexpresshd';
    }
    if (lowerPkg.contains('temu') || lowerName == 'temu') {
      return 'com.einnovation.temu';
    }
    if (lowerPkg.contains('twitter') || lowerName == 'twitter' || lowerName == 'x') {
      return 'com.twitter.android';
    }
    if (lowerPkg.contains('discord') || lowerName == 'discord') {
      return 'com.discord';
    }
    if (lowerPkg.contains('telegram') || lowerName == 'telegram') {
      return 'org.telegram.messenger';
    }
    if (lowerPkg.contains('netflix') || lowerName == 'netflix') {
      return 'com.netflix.mediaclient';
    }
    if (lowerPkg.contains('spotify') || lowerName == 'spotify') {
      return 'com.spotify.music';
    }
    return pkg;
  }

  /// Determina si un paquete corresponde a un distractor digital prioritario predeterminado.
  static bool isDefaultDistractor(String packageName, String name) {
    final lowerPkg = packageName.toLowerCase();
    final lowerName = name.toLowerCase();
    if (lowerPkg.contains('instagram') || lowerName.contains('instagram')) return true;
    if (lowerPkg.contains('tiktok') ||
        lowerPkg.contains('musically') ||
        lowerName.contains('tiktok')) {
      return true;
    }
    if (lowerPkg.contains('whatsapp') || lowerName.contains('whatsapp')) return true;
    if (lowerPkg.contains('facebook') ||
        lowerPkg.contains('katana') ||
        lowerName.contains('facebook')) {
      return true;
    }
    if (lowerPkg.contains('aliexpress') || lowerName.contains('aliexpress')) return true;
    return false;
  }

  /// Consulta el catálogo de aplicaciones disponibles en el dispositivo o catálogo seguro.
  Future<List<BlockedApp>> getAvailableApps(String userId) async {
    final prefs = await _getPrefs();
    final savedJson = prefs.getString('blocked_apps_$userId');

    final Map<String, bool> blockedMap = {};
    final List<BlockedApp> savedList = [];
    if (savedJson != null) {
      try {
        final decoded = jsonDecode(savedJson);
        if (decoded is List) {
          for (final item in decoded) {
            final map = item is Map<String, dynamic>
                ? item
                : Map<String, dynamic>.from(item as Map);
            var app = BlockedApp.fromJson(map);
            final canonical = resolveCanonicalPackage(app.packageName, app.name);
            if (canonical != app.packageName) {
              app = app.copyWith(packageName: canonical, id: canonical);
            }
            savedList.add(app);
            blockedMap[app.id] = app.isBlocked;
            blockedMap[app.packageName] = app.isBlocked;
            blockedMap[app.name.toLowerCase()] = app.isBlocked;
          }
        }
      } catch (e) {
        debugPrint('Error parsing saved blocked apps: $e');
      }
    }

    final hasUserConfigured = blockedMap.isNotEmpty;

    // Si estamos en Android nativo no-web, intentamos consultar los paquetes instalados
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        final List<AppInfo> installed;
        if (_cachedInstalledAppsRaw != null && _cachedInstalledAppsRaw!.isNotEmpty) {
          installed = _cachedInstalledAppsRaw!;
        } else {
          installed = await InstalledApps.getInstalledApps(
            excludeSystemApps: true,
            withIcon: false,
          );
          _cachedInstalledAppsRaw = installed;
        }

        if (installed.isNotEmpty) {
          final List<BlockedApp> result = [];
          for (final app in installed) {
            // Filtrar paquetes internos de mindUC
            if (app.packageName == 'com.example.minduc' ||
                app.packageName == 'com.minduc.app' ||
                app.packageName == 'com.minduc.minduc') {
              continue;
            }

            final canonical = resolveCanonicalPackage(app.packageName, app.name);
            final isBlocked = hasUserConfigured
                ? (blockedMap[canonical] ??
                    blockedMap[app.packageName] ??
                    blockedMap[app.name.toLowerCase()] ??
                    false)
                : isDefaultDistractor(canonical, app.name);

            result.add(
              BlockedApp(
                id: canonical,
                name: app.name,
                packageName: canonical,
                category: _categorizePackage(canonical),
                isBlocked: isBlocked,
                dotColorValue: _colorForPackage(canonical),
              ),
            );
          }

          // Asegurar que las apps distractoras principales siempre estén disponibles
          for (final defApp in BlockedApp.defaultApps) {
            final exists = result.any((a) =>
                a.packageName == defApp.packageName ||
                a.id == defApp.id ||
                a.name.toLowerCase() == defApp.name.toLowerCase());
            if (!exists) {
              final isBlocked = hasUserConfigured
                  ? (blockedMap[defApp.id] ??
                      blockedMap[defApp.packageName] ??
                      blockedMap[defApp.name.toLowerCase()] ??
                      defApp.isBlocked)
                  : defApp.isBlocked;
              result.add(defApp.copyWith(isBlocked: isBlocked));
            }
          }

          // Incorporar aplicaciones personalizadas o guardadas previamente
          for (final savedApp in savedList) {
            final exists = result.any((a) =>
                a.id == savedApp.id ||
                a.packageName == savedApp.packageName ||
                a.name.toLowerCase() == savedApp.name.toLowerCase());
            if (!exists) {
              result.add(savedApp);
            }
          }

          if (result.isNotEmpty) {
            return result;
          }
        }
      } catch (e) {
        debugPrint('InstalledApps not available or platform error: $e');
      }
    }

    // Catálogo por defecto para entorno Web, emuladores o pruebas
    final defaults = List<BlockedApp>.from(BlockedApp.defaultApps);
    final mappedDefaults = defaults.map((app) {
      if (hasUserConfigured) {
        final isSelected = blockedMap[app.id] ??
            blockedMap[app.packageName] ??
            blockedMap[app.name.toLowerCase()] ??
            false;
        return app.copyWith(isBlocked: isSelected);
      }
      return app;
    }).toList();

    // Incorporar aplicaciones personalizadas agregadas por el usuario que no estén en defaults
    for (final customApp in savedList) {
      final exists = mappedDefaults.any((a) =>
          a.id == customApp.id ||
          a.packageName == customApp.packageName ||
          a.name.toLowerCase() == customApp.name.toLowerCase());
      if (!exists) {
        mappedDefaults.add(customApp);
      }
    }

    return mappedDefaults;
  }

  /// Obtiene únicamente las aplicaciones que están marcadas como bloqueadas para el usuario.
  Future<List<BlockedApp>> getBlockedApps(String userId) async {
    final available = await getAvailableApps(userId);
    return available.where((app) => app.isBlocked).toList();
  }

  /// Guarda la configuración de aplicaciones del usuario en SharedPreferences y actualiza el servicio nativo.
  Future<void> saveBlockedApps(String userId, List<BlockedApp> apps) async {
    final prefs = await _getPrefs();
    final sanitizedApps = apps.map((a) {
      final canonical = resolveCanonicalPackage(a.packageName, a.name);
      if (canonical != a.packageName) {
        return a.copyWith(packageName: canonical, id: canonical);
      }
      return a;
    }).toList();

    final jsonList = sanitizedApps.map((a) => a.toJson()).toList();
    await prefs.setString('blocked_apps_$userId', jsonEncode(jsonList));

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final isEnabled = prefs.getBool('blocker_active_$userId') ?? false;
      if (isEnabled) {
        try {
          final packages = sanitizedApps
              .where((a) => a.isBlocked)
              .map((a) => a.packageName)
              .toSet()
              .toList();
          await _channel.invokeMethod('startBlocker', {'packages': packages});
        } catch (_) {}
      }
    }
  }

  /// Evalúa el estado real de los permisos y compatibilidad de la plataforma.
  Future<BlockerPermissionStatus> checkPermissionStatus({
    required bool isEnabled,
  }) async {
    if (!isEnabled) {
      return BlockerPermissionStatus.inactive;
    }

    // En navegador Web no hay permisos del SO para restringir procesos de terceros
    if (kIsWeb) {
      return BlockerPermissionStatus.webRestricted;
    }

    // En Android se requiere SystemAlertWindow y UsageStats
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        final res = await _channel.invokeMapMethod<String, dynamic>('checkPermissions');
        if (res != null) {
          final usageStats = res['usageStats'] as bool? ?? false;
          final overlay = res['overlay'] as bool? ?? false;
          if (!usageStats || !overlay) {
            return BlockerPermissionStatus.pendingPermissions;
          }
          return BlockerPermissionStatus.active;
        }
      } catch (_) {}

      try {
        final overlayStatus = await Permission.systemAlertWindow.status;
        if (!overlayStatus.isGranted) {
          return BlockerPermissionStatus.pendingPermissions;
        }
        return BlockerPermissionStatus.active;
      } catch (e) {
        debugPrint('Permission check error on Android: $e');
        return BlockerPermissionStatus.pendingPermissions;
      }
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS restringe ScreenTime a entitlements de desarrollador específicos
      return BlockerPermissionStatus.pendingPermissions;
    }

    // En entornos desktop o de prueba
    return BlockerPermissionStatus.active;
  }

  /// Abre la configuración del dispositivo para solicitar los permisos necesarios.
  Future<bool> requestPermissions() async {
    if (kIsWeb) {
      return false;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _channel.invokeMethod('requestPermissions');
        return true;
      } catch (_) {}

      try {
        final status = await Permission.systemAlertWindow.request();
        if (status.isGranted) {
          return true;
        }
        // Si no está concedido, redirigir a configuración de la app
        return await openAppSettings();
      } catch (e) {
        debugPrint('Error requesting permissions: $e');
        return false;
      }
    }

    return await openAppSettings();
  }

  /// Guarda el estado de activación del bloqueo para el usuario e inicia/detiene el monitor nativo.
  Future<void> setBlockerActive(
    String userId,
    bool active, {
    int durationMinutes = 25,
  }) async {
    final prefs = await _getPrefs();
    await prefs.setBool('blocker_active_$userId', active);
    await prefs.setInt('blocker_duration_$userId', durationMinutes);

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        if (active) {
          var blocked = await getBlockedApps(userId);
          if (blocked.isEmpty) {
            final available = await getAvailableApps(userId);
            final defaults = available.where((a) => a.isBlocked).toList();
            if (defaults.isNotEmpty) {
              blocked = defaults;
            } else {
              blocked = BlockedApp.defaultApps.take(3).toList();
            }
          }
          final packages = blocked
              .map((a) => resolveCanonicalPackage(a.packageName, a.name))
              .toSet()
              .toList();
          await _channel.invokeMethod('startBlocker', {
            'packages': packages,
            'durationMinutes': durationMinutes,
          });
        } else {
          await _channel.invokeMethod('stopBlocker');
        }
      } catch (e) {
        debugPrint('Error setting native blocker active: $e');
      }
    }
  }

  /// Consulta si el bloqueo está activo para el usuario.
  Future<bool> isBlockerActive(String userId) async {
    final prefs = await _getPrefs();
    return prefs.getBool('blocker_active_$userId') ?? false;
  }

  /// Obtiene la duración configurada para el bloqueo en minutos.
  Future<int> getBlockingDuration(String userId) async {
    final prefs = await _getPrefs();
    return prefs.getInt('blocker_duration_$userId') ?? 25;
  }

  /// Guarda la duración configurada para el bloqueo en minutos.
  Future<void> saveBlockingDuration(String userId, int minutes) async {
    final prefs = await _getPrefs();
    await prefs.setInt('blocker_duration_$userId', minutes);
  }

  String _categorizePackage(String pkg) {
    final lower = pkg.toLowerCase();
    if (lower.contains('instagram') ||
        lower.contains('tiktok') ||
        lower.contains('facebook') ||
        lower.contains('twitter') ||
        lower.contains('reddit')) {
      return 'Redes sociales';
    }
    if (lower.contains('whatsapp') ||
        lower.contains('telegram') ||
        lower.contains('discord') ||
        lower.contains('messenger')) {
      return 'Mensajería';
    }
    if (lower.contains('youtube') ||
        lower.contains('netflix') ||
        lower.contains('twitch') ||
        lower.contains('prime') ||
        lower.contains('hbo')) {
      return 'Streaming & Video';
    }
    if (lower.contains('game') ||
        lower.contains('play') ||
        lower.contains('roblox')) {
      return 'Juegos';
    }
    return 'Aplicación general';
  }

  int _colorForPackage(String pkg) {
    final lower = pkg.toLowerCase();
    if (lower.contains('instagram')) return 0xFFE53935;
    if (lower.contains('tiktok')) return 0xFF7E57C2;
    if (lower.contains('whatsapp')) return 0xFF43A047;
    if (lower.contains('youtube')) return 0xFFFF0000;
    if (lower.contains('twitter')) return 0xFF1DA1F2;
    if (lower.contains('facebook')) return 0xFF1877F2;
    if (lower.contains('netflix')) return 0xFFE50914;
    return 0xFF5D8572;
  }
}
