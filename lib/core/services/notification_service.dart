import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Modelo que representa un registro de notificación mostrado al usuario
class AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String category; // 'pomodoro', 'agenda', 'bienestar'
  final bool isRead;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.category,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'category': category,
        'isRead': isRead,
      };

  factory AppNotificationItem.fromJson(Map<String, dynamic> json) =>
      AppNotificationItem(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
            DateTime.now(),
        category: json['category'] as String? ?? 'bienestar',
        isRead: json['isRead'] as bool? ?? false,
      );
}

/// Servicio centralizado de notificaciones locales nativas para mindUC.
/// Gestiona alertas de Pomodoro, recordatorios de Agenda y pausas conscientes.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  SharedPreferences? _cachedPrefs;
  final List<AppNotificationItem> _history = [];

  List<AppNotificationItem> get history => List.unmodifiable(_history);

  // Canales oficiales de Android
  static const String channelPomodoroId = 'minduc_pomodoro';
  static const String channelAgendaId = 'minduc_agenda_v3';
  static const String channelWellnessId = 'minduc_wellness';

  /// Intervalos estándar de aviso previo para la agenda (en minutos)
  static const List<int> standardReminderMinutes = [1440, 120, 30, 15, 10, 5, 0];

  /// Inicializa el motor de notificaciones y la base de zonas horarias
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      final offset = DateTime.now().timeZoneOffset;
      for (final loc in tz.timeZoneDatabase.locations.values) {
        if (loc.currentTimeZone.offset == offset) {
          tz.setLocalLocation(loc);
          break;
        }
      }
    } catch (e) {
      debugPrint('[NotificationService] Error inicializando timezones: $e');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint(
              '[NotificationService] Notificación seleccionada: ${response.payload}');
        },
      );

      // Crear canales explícitos en Android con máxima importancia
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            channelAgendaId,
            'Actividades de la Agenda',
            description: 'Recordatorios de actividades de la agenda mindUC',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            channelPomodoroId,
            'Concentración Pomodoro',
            description: 'Alertas de intervalos y pausas conscientes Pomodoro',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            channelWellnessId,
            'Bienestar y Pausas Conscientes',
            description: 'Recordatorios de pausas activas y bienestar',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );
      }

      _isInitialized = true;
      await _loadHistory();
      debugPrint('[NotificationService] Motor de notificaciones inicializado.');
    } catch (e) {
      debugPrint('[NotificationService] Error al inicializar plugin: $e');
    }
  }

  /// Solicita permisos de notificación al usuario (Android 13+ y iOS)
  Future<bool> requestPermission() async {
    try {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final notifGranted =
            await androidPlugin.requestNotificationsPermission();
        try {
          await androidPlugin.requestExactAlarmsPermission();
        } catch (_) {}
        if (notifGranted == true) return true;
      }
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('[NotificationService] Error solicitando permisos: $e');
      return false;
    }
  }

  /// Muestra una notificación inmediata
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = channelWellnessId,
    String channelName = 'Bienestar y Recordatorios',
  }) async {
    await initialize();

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Alertas conscientes y de productividad de mindUC',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );

      _addHistoryItem(
        title: title,
        body: body,
        category: _channelToCategory(channelId),
      );
    } catch (e) {
      debugPrint('[NotificationService] Error al mostrar notificación: $e');
    }
  }

  /// Programa una notificación para una fecha y hora específica
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String channelId = channelAgendaId,
    String channelName = 'Actividades de la Agenda',
    String? payload,
  }) async {
    await initialize();

    final now = DateTime.now();
    if (scheduledDate.isBefore(now)) {
      debugPrint(
          '[NotificationService] No se programa notificación: fecha ya pasó ($scheduledDate)');
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Recordatorios de actividades de la agenda mindUC',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      fullScreenIntent: true,
      category: AndroidNotificationCategory.reminder,
      enableVibration: true,
      playSound: true,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzDateTime,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      _addHistoryItem(
        title: title,
        body: body,
        category: _channelToCategory(channelId),
      );

      debugPrint(
          '[NotificationService] Notificación programada ID: $id para $scheduledDate');
    } catch (e) {
      debugPrint('[NotificationService] Error programando notificación: $e');
      // Fallback: Si exact alarm no está permitido, intentar con modo inexacto
      try {
        final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);
        await _plugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzDateTime,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexact,
          payload: payload,
        );

        _addHistoryItem(
          title: title,
          body: body,
          category: _channelToCategory(channelId),
        );
      } catch (_) {}
    }
  }

  /// Cancela una notificación específica
  Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id: id);
    } catch (e) {
      debugPrint('[NotificationService] Error al cancelar notificación $id: $e');
    }
  }

  /// Cancela todas las notificaciones
  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('[NotificationService] Error al cancelar todo: $e');
    }
  }

  // ===========================================================================
  // MÉTODOS ESPECIALIZADOS DEL FLUJO MIND-UC
  // ===========================================================================

  /// Emite la notificación de descanso Pomodoro al culminar un intervalo de concentración
  Future<void> showPomodoroBreakNotification() async {
    await showNotification(
      id: 1001,
      title: '¡Ciclo de concentración completado! 🌿',
      body: 'Has cumplido tus 25 minutos de enfoque. Tómate una pausa de 5 min para descansar.',
      channelId: channelPomodoroId,
      channelName: 'Concentración Pomodoro',
    );
  }

  /// Emite la notificación de reanudación Pomodoro
  Future<void> showPomodoroFocusNotification() async {
    await showNotification(
      id: 1002,
      title: '¡Pausa finalizada! 🎯',
      body: 'Es momento de volver a enfocar tu atención en tu objetivo académico.',
      channelId: channelPomodoroId,
      channelName: 'Concentración Pomodoro',
    );
  }

  /// Emite un recordatorio compasivo si el estudiante sale de la app durante el Modo Enfoque Profundo
  Future<void> showDeepFocusDistractionNotice({required int blockedCount}) async {
    await showNotification(
      id: 1003,
      title: 'Modo Enfoque Profundo activo 🛡️',
      body: 'Tienes $blockedCount apps silenciadas para cuidar tu concentración. ¡Regresa a mindUC para culminar tu sesión!',
      channelId: channelPomodoroId,
      channelName: 'Concentración Pomodoro',
    );
  }

  /// Emite un recordatorio consciente de pausa activa
  Future<void> showMindfulPauseReminder() async {
    await showNotification(
      id: 2001,
      title: 'Momento de una pausa consciente 🌸',
      body: 'Llevas un buen tiempo de estudio. Regálate 2 minutos para estirar el cuello o respirar.',
      channelId: channelWellnessId,
      channelName: 'Pausas Conscientes de Bienestar',
    );
  }

  /// Genera un ID determinista único de 31 bits para cada alarma de una actividad
  int generateReminderId(String activityId, int minutesBefore) {
    return ((activityId.hashCode.abs() % 100000) * 31 + minutesBefore).abs() %
        2147483647;
  }

  /// Cancela todos los recordatorios/alarmas asociados a una actividad de la agenda
  Future<void> cancelAgendaActivityReminders(String activityId) async {
    // Cancelar ID legacy si existía
    await cancelNotification(activityId.hashCode.abs() % 100000);
    // Cancelar todos los posibles IDs generados para cada intervalo estándar
    for (final mins in standardReminderMinutes) {
      await cancelNotification(generateReminderId(activityId, mins));
    }
  }

  /// Programa múltiples recordatorios o alarmas para una actividad de la Agenda.
  /// Si la app está en segundo plano o cerrada, el AlarmManager nativo de Android
  /// despertará el dispositivo según la configuración exacta configurada.
  Future<void> scheduleAgendaActivityReminders({
    required String activityId,
    required String title,
    required DateTime scheduledDateTime,
    required List<int> reminderMinutesList,
  }) async {
    await cancelAgendaActivityReminders(activityId);

    final now = DateTime.now();
    // Si la actividad ocurrió hace más de 5 minutos, no programar
    if (scheduledDateTime.isBefore(now.subtract(const Duration(minutes: 5)))) {
      debugPrint(
          '[NotificationService] La actividad ya caducó ($scheduledDateTime).');
      return;
    }

    for (final minutesBefore in reminderMinutesList) {
      DateTime notificationTime =
          scheduledDateTime.subtract(Duration(minutes: minutesBefore));

      // Si la hora del recordatorio ya pasó
      if (notificationTime.isBefore(now)) {
        // Solo alertamos de inmediato si es la hora misma del evento (0 min)
        // y el evento está ocurriendo en este instante (o hace menos de 2 min)
        if (minutesBefore == 0 &&
            scheduledDateTime.difference(now).inMinutes.abs() <= 2) {
          notificationTime = now.add(const Duration(seconds: 3));
        } else {
          // Avisos anticipados pasados (ej: "1 día antes" para un evento creado hoy) se ignoran
          continue;
        }
      }

      final id = generateReminderId(activityId, minutesBefore);

      String timeLabel;
      if (minutesBefore >= 1440) {
        timeLabel = 'en 1 día';
      } else if (minutesBefore >= 120) {
        timeLabel = 'en 2 horas';
      } else if (minutesBefore == 30) {
        timeLabel = 'en media hora';
      } else if (minutesBefore == 15) {
        timeLabel = 'en 15 minutos';
      } else if (minutesBefore == 10) {
        timeLabel = 'en 10 minutos';
      } else if (minutesBefore == 5) {
        timeLabel = 'en 5 minutos';
      } else {
        timeLabel = 'ahora';
      }

      await scheduleNotification(
        id: id,
        title: 'Recordatorio de Agenda: $title 📅',
        body: minutesBefore == 0 || notificationTime == scheduledDateTime
            ? 'Es hora de tu actividad: "$title" 🌿'
            : 'Tu actividad "$title" comienza $timeLabel.',
        scheduledDate: notificationTime,
        channelId: channelAgendaId,
        channelName: 'Actividades de la Agenda',
      );
    }
  }

  /// Compatibilidad retroactiva: Programa una sola alarma anticipada
  Future<void> scheduleAgendaActivityReminder({
    required String activityId,
    required String title,
    required DateTime scheduledDateTime,
    required int minutesBefore,
  }) async {
    await scheduleAgendaActivityReminders(
      activityId: activityId,
      title: title,
      scheduledDateTime: scheduledDateTime,
      reminderMinutesList: [minutesBefore],
    );
  }

  // ===========================================================================
  // BANDEJA / HISTORIAL LOCAL DE NOTIFICACIONES
  // ===========================================================================

  void _addHistoryItem({
    required String title,
    required String body,
    required String category,
  }) {
    final item = AppNotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
      category: category,
    );
    _history.insert(0, item);
    if (_history.length > 50) {
      _history.removeLast();
    }
    _saveHistory();
  }

  Future<SharedPreferences> _getPrefs() async {
    return _cachedPrefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await _getPrefs();
      final raw = prefs.getString('minduc_notification_history');
      if (raw != null) {
        final list = jsonDecode(raw) as List;
        _history.clear();
        for (final item in list) {
          _history.add(AppNotificationItem.fromJson(item as Map<String, dynamic>));
        }
      }
    } catch (_) {}
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await _getPrefs();
      final raw = jsonEncode(_history.map((e) => e.toJson()).toList());
      await prefs.setString('minduc_notification_history', raw);
    } catch (_) {}
  }

  Future<void> clearHistory() async {
    _history.clear();
    await _saveHistory();
  }

  String _channelToCategory(String channelId) {
    if (channelId == channelPomodoroId) return 'pomodoro';
    if (channelId == channelAgendaId) return 'agenda';
    return 'bienestar';
  }
}
