# Contract: Navigation Router

`lib/core/router/app_router.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const String initial = '/';
  static const String auth = '/auth';
  
  // Shell Tabs
  static const String home = '/home';
  static const String wellness = '/wellness';
  static const String agenda = '/agenda';
  static const String profile = '/profile';
  
  // Sub-routes / Modals
  static const String schedulerModal = '/scheduler-modal';
  static const String breathingSession = '/breathing-session';
  static const String pomodoroSession = '/pomodoro-session';
  static const String journalNew = '/journal/new';
  static const String forum = '/forum';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellHomeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellWellnessNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellAgendaNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellProfileNavigatorKey = GlobalKey<NavigatorState>();
```

