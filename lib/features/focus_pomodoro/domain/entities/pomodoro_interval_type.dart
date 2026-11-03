/// Tipos de intervalo configurables en la técnica Pomodoro.
enum PomodoroIntervalType {
  focus,
  shortBreak,
  longBreak;

  /// Etiqueta visual para la interfaz de usuario.
  String get label {
    switch (this) {
      case PomodoroIntervalType.focus:
        return 'Enfoque';
      case PomodoroIntervalType.shortBreak:
        return 'Corto (5m)';
      case PomodoroIntervalType.longBreak:
        return 'Largo (15m)';
    }
  }

  /// Duración predeterminada en segundos.
  int get defaultDurationSeconds {
    switch (this) {
      case PomodoroIntervalType.focus:
        return 1500; // 25 min
      case PomodoroIntervalType.shortBreak:
        return 300; // 5 min
      case PomodoroIntervalType.longBreak:
        return 900; // 15 min
    }
  }
}

